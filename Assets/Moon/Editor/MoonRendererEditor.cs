using UnityEngine;
using UnityEditor;

[CanEditMultipleObjects]
[CustomEditor(typeof(MoonRenderer))]
public class MoonRendererEditor : Editor
{
    SerializedProperty _segments;
    SerializedProperty _rings;
    SerializedProperty _colorSaturation;
    SerializedProperty _smoothness;
    SerializedProperty _normalScale;
    SerializedProperty _castShadows;
    SerializedProperty _receiveShadows;

    static GUIContent _textBaseSaturation = new GUIContent("Base Saturation");

    void OnEnable()
    {
        _segments = serializedObject.FindProperty("_segments");
        _rings    = serializedObject.FindProperty("_rings");

        _colorSaturation = serializedObject.FindProperty("_colorSaturation");
        _smoothness      = serializedObject.FindProperty("_smoothness");
        _normalScale     = serializedObject.FindProperty("_normalScale");

        _castShadows    = serializedObject.FindProperty("_castShadows");
        _receiveShadows = serializedObject.FindProperty("_receiveShadows");
    }

    public override void OnInspectorGUI()
    {
        var instance = target as MoonRenderer;

        serializedObject.Update();

        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(_segments);
        EditorGUILayout.PropertyField(_rings);
        if (EditorGUI.EndChangeCheck()) instance.NotifyConfigChange();

        EditorGUILayout.Space();

        EditorGUILayout.PropertyField(_colorSaturation, _textBaseSaturation);
        EditorGUILayout.PropertyField(_smoothness);
        EditorGUILayout.PropertyField(_normalScale);

        EditorGUILayout.Space();

        EditorGUILayout.PropertyField(_castShadows);
        EditorGUILayout.PropertyField(_receiveShadows);

        serializedObject.ApplyModifiedProperties();
    }
}
