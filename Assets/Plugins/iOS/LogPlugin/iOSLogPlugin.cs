using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class iOSLogPlugin : MonoBehaviour
{
    #if UNITY_IOS && !UNITY_EDITOR

    [DllImport("__Internal")]
    private static extern void _CreatePointOfInterest(string name, string message);
    
    [DllImport("__Internal")]
    private static extern void _StartRegionOfInterest(uint id, string name, string message);

    [DllImport("__Internal")]
    private static extern void _EndRegionOfInterest(uint id, string name);

    private static void Internal_CreatePointOfInterest(string name, string message)
    {
        _CreatePointOfInterest(name, message);
    }

    private static void Internal_StartRegionOfInterest(uint id, string name, string message)
    {
        _StartRegionOfInterest(id, name, message);
    }

    private static void Internal_EndRegionOfInterest(uint id, string name)
    {
        _EndRegionOfInterest(id, name);
    }

    public static void CreatePointOfInterest(string name, string message)
    {
        Internal_CreatePointOfInterest(name, message);
    }

    private static Dictionary<uint, string> _map = new Dictionary<uint, string>();
    private static uint _eventId;

    public static uint StartRegionOfInterest(string name, string message)
    {
        _eventId++;
        _map.Add(_eventId, name);
        Internal_StartRegionOfInterest(_eventId, name, message);
        
        return _eventId;
    }

    public static void EndRegionOfInterest(uint id)
    {
        if(_map.ContainsKey(id) == false)
            return;
        
        Internal_EndRegionOfInterest(id, _map[id]);
        _map.Remove(id);
    }

    #else

    public static void CreatePointOfInterest(string name, string message){}

    public static uint StartRegionOfInterest(string name, string message)
    {
        return 0;
    }
    public static void EndRegionOfInterest(uint id){}
    
    #endif
}
