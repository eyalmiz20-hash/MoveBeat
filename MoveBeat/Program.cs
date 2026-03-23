using System;
using System.Linq;
using Microsoft.Kinect;

class Program
{
    static KinectSensor sensor;
    static BodyFrameReader bodyReader;
    static Body[] bodies;

    static void Main()
    {
        Console.WriteLine("Starting Kinect body test...");

        try
        {
            sensor = KinectSensor.GetDefault();

            if (sensor == null)
            {
                Console.WriteLine("Kinect not found");
                Console.ReadLine();
                return;
            }

            bodyReader = sensor.BodyFrameSource.OpenReader();
            bodyReader.FrameArrived += BodyReader_FrameArrived;

            sensor.Open();

            Console.WriteLine("Kinect opened");
            Console.WriteLine("Stand in front of the Kinect...");
            Console.WriteLine("Press ENTER to exit...");
            Console.ReadLine();

            bodyReader.FrameArrived -= BodyReader_FrameArrived;
            bodyReader.Dispose();
            sensor.Close();
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex);
            Console.ReadLine();
        }
    }

    static void BodyReader_FrameArrived(object sender, BodyFrameArrivedEventArgs e)
    {
        using (var frame = e.FrameReference.AcquireFrame())
        {
            if (frame == null)
                return;

            if (bodies == null)
                bodies = new Body[frame.BodyCount];

            frame.GetAndRefreshBodyData(bodies);

            var trackedBody = bodies.FirstOrDefault(b => b != null && b.IsTracked);

            Console.Clear();

            if (trackedBody == null)
            {
                Console.WriteLine("No body tracked");
                return;
            }

            var head = trackedBody.Joints[JointType.Head].Position;
            var handRight = trackedBody.Joints[JointType.HandRight].Position;
            var handLeft = trackedBody.Joints[JointType.HandLeft].Position;
            var spineBase = trackedBody.Joints[JointType.SpineBase].Position;

            Console.WriteLine("Body tracked!");
            Console.WriteLine($"Head      : X={head.X:F3} Y={head.Y:F3} Z={head.Z:F3}");
            Console.WriteLine($"HandRight : X={handRight.X:F3} Y={handRight.Y:F3} Z={handRight.Z:F3}");
            Console.WriteLine($"HandLeft  : X={handLeft.X:F3} Y={handLeft.Y:F3} Z={handLeft.Z:F3}");
            Console.WriteLine($"SpineBase : X={spineBase.X:F3} Y={spineBase.Y:F3} Z={spineBase.Z:F3}");
        }
    }
}