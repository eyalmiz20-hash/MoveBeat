// Data-driven stub of the Kinect v2 surface MoveBeat/Program.cs touches, so the real
// body-selection code can be RUN on the Mac.  Scratchpad only; never in the repo.
using System;
using System.Collections.Generic;

namespace Microsoft.Kinect
{
    public enum TrackingState { NotTracked = 0, Inferred = 1, Tracked = 2 }

    public enum JointType
    {
        SpineBase = 0, SpineMid, Neck, Head, ShoulderLeft, ElbowLeft, WristLeft,
        HandLeft, ShoulderRight, ElbowRight, WristRight, HandRight, HipLeft,
        KneeLeft, AnkleLeft, FootLeft, HipRight, KneeRight, AnkleRight, FootRight,
        SpineShoulder, HandTipLeft, ThumbLeft, HandTipRight, ThumbRight
    }

    public struct CameraSpacePoint { public float X, Y, Z; }

    public struct Joint
    {
        public JointType JointType;
        public CameraSpacePoint Position;
        public TrackingState TrackingState;
    }

    public class JointCollection
    {
        readonly Dictionary<JointType, Joint> _j = new Dictionary<JointType, Joint>();
        public void Set(JointType t, float x, TrackingState st)
        {
            Joint j = new Joint();
            j.JointType = t;
            j.TrackingState = st;
            CameraSpacePoint p = new CameraSpacePoint();
            p.X = x;
            j.Position = p;
            _j[t] = j;
        }
        public Joint this[JointType t]
        {
            get { return _j.ContainsKey(t) ? _j[t] : default(Joint); }
        }
    }

    // The scenario the test sets up: which bodies the sensor is reporting this frame.
    public static class Scenario
    {
        public static Body[] Bodies = new Body[6];
    }

    public class Body
    {
        public bool TrackedFlag;
        public ulong Id;
        public JointCollection JointData = new JointCollection();
        public bool IsTracked { get { return TrackedFlag; } }
        public ulong TrackingId { get { return Id; } }
        public JointCollection Joints { get { return JointData; } }

        public static Body At(ulong id, float spineX, TrackingState st = TrackingState.Tracked)
        {
            Body b = new Body();
            b.TrackedFlag = true;
            b.Id = id;
            b.JointData.Set(JointType.SpineBase, spineX, st);
            return b;
        }
    }

    public class BodyFrame : IDisposable
    {
        public int BodyCount { get { return Scenario.Bodies.Length; } }
        public void GetAndRefreshBodyData(Body[] bodies)
        {
            for (int i = 0; i < bodies.Length && i < Scenario.Bodies.Length; i++)
                bodies[i] = Scenario.Bodies[i];
        }
        public void Dispose() { }
    }

    public class BodyFrameReference
    {
        public BodyFrame AcquireFrame() { return new BodyFrame(); }
    }

    public class BodyFrameArrivedEventArgs : EventArgs
    {
        public BodyFrameReference FrameReference { get { return new BodyFrameReference(); } }
    }

    public class BodyFrameSource
    {
        public int BodyCount { get { return 6; } }
        public BodyFrameReader OpenReader() { return null; }
    }

    public class BodyFrameReader : IDisposable
    {
        public event EventHandler<BodyFrameArrivedEventArgs> FrameArrived;
        public void Dispose() { if (FrameArrived != null) { } }
    }

    public class IsAvailableChangedEventArgs : EventArgs
    {
        public bool IsAvailable { get { return false; } }
    }

    public class KinectSensor
    {
        public static KinectSensor GetDefault() { return null; }
        public bool IsOpen { get { return false; } }
        public bool IsAvailable { get { return false; } }
        public BodyFrameSource BodyFrameSource { get { return null; } }
        public event EventHandler<IsAvailableChangedEventArgs> IsAvailableChanged;
        public void Open() { }
        public void Close() { if (IsAvailableChanged != null) { } }
    }
}
