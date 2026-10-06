// Drives the REAL BodyReader_FrameArrived in MoveBeat/Program.cs and reads back the
// followedTrackingId field, so the body lock is tested rather than merely compiled.
using System;
using System.Reflection;
using Microsoft.Kinect;

static class TestBodyLock
{
    static MethodInfo _handler;
    static FieldInfo _followed, _bodies;
    static int pass, fail;

    static void Frame()
    {
        _handler.Invoke(null, new object[] { null, new BodyFrameArrivedEventArgs() });
    }

    static ulong Followed { get { return (ulong)_followed.GetValue(null); } }

    static void Check(string name, bool ok, string detail)
    {
        Console.WriteLine("  {0,-56} {1}   {2}", name, ok ? "PASS" : "FAIL", detail);
        if (ok) pass++; else fail++;
    }

    static int Main()
    {
        Type p = typeof(Microsoft.Kinect.Body).Assembly.GetType("Program");
        _handler = p.GetMethod("BodyReader_FrameArrived",
            BindingFlags.NonPublic | BindingFlags.Static);
        _followed = p.GetField("followedTrackingId",
            BindingFlags.NonPublic | BindingFlags.Static);
        _bodies = p.GetField("bodies", BindingFlags.NonPublic | BindingFlags.Static);
        if (_handler == null || _followed == null)
        {
            Console.WriteLine("could not reflect into Program - handler={0} field={1}",
                _handler, _followed);
            return 2;
        }

        Console.WriteLine("=== the body lock, driven through the real frame handler ===");

        // 1. Two bodies. The OFF-CENTRE one sits at the lower array index, which is what
        //    the old "first tracked body" rule would have picked.
        Scenario.Bodies = new Body[6];
        Scenario.Bodies[0] = Body.At(5UL, -1.50f);   // far left
        Scenario.Bodies[3] = Body.At(7UL, +0.10f);   // near the centre line
        Frame();
        Check("picks the body nearest centre, not the lowest index", Followed == 7UL,
              "following " + Followed);

        // 2. Same two bodies, array order SWAPPED - the exact thing that used to flip the
        //    stream frame to frame. The lock must not move.
        for (int i = 0; i < 12; i++)
        {
            Scenario.Bodies = new Body[6];
            Scenario.Bodies[(i % 2 == 0) ? 1 : 4] = Body.At(7UL, +0.10f);
            Scenario.Bodies[(i % 2 == 0) ? 4 : 1] = Body.At(5UL, -1.50f);
            Frame();
            if (Followed != 7UL)
                break;
        }
        Check("holds that body across 12 frames of index churn", Followed == 7UL,
              "following " + Followed);

        // 3. A NEW, better-centred body appears. The lock must still not move - a body
        //    walking into the middle of the frame may not steal the stream mid-piece.
        Scenario.Bodies = new Body[6];
        Scenario.Bodies[0] = Body.At(9UL, 0.00f);    // dead centre, and not ours
        Scenario.Bodies[2] = Body.At(7UL, +0.60f);   // ours, drifted off centre
        Frame();
        Check("a better-centred newcomer does not steal the stream", Followed == 7UL,
              "following " + Followed);

        // 4. Ours leaves. Now it may re-choose, and takes the nearest centre.
        Scenario.Bodies = new Body[6];
        Scenario.Bodies[0] = Body.At(5UL, -1.50f);
        Scenario.Bodies[1] = Body.At(9UL, -0.20f);
        Frame();
        Check("re-chooses the nearest centre once ours is gone", Followed == 9UL,
              "following " + Followed);

        // 5. Nobody at all: the lock is released, so the next body is chosen freshly.
        Scenario.Bodies = new Body[6];
        Frame();
        Check("releases the lock when nobody is in view", Followed == 0UL,
              "following " + Followed);

        // 6. A body whose spine base is not tracked must not win on a 0,0,0 position.
        Scenario.Bodies = new Body[6];
        Scenario.Bodies[0] = Body.At(11UL, 0.00f, TrackingState.NotTracked);
        Scenario.Bodies[1] = Body.At(13UL, +0.40f, TrackingState.Tracked);
        Frame();
        Check("an untracked spine base does not read as perfectly centred",
              Followed == 13UL, "following " + Followed);

        Console.WriteLine("  {0}/{1} PASS", pass, pass + fail);
        return fail == 0 ? 0 : 1;
    }
}
