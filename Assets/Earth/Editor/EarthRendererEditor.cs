using UnityEngine;
using UnityEditor;

[CanEditMultipleObjects]
[CustomEditor(typeof(EarthRenderer))]
public class EarthRendererEditor : Editor
{
    SerializedProperty _segments;
    SerializedProperty _rings;
    SerializedProperty _colorSaturation;
    SerializedProperty _seaColor;
    SerializedProperty _smoothness;
    SerializedProperty _cloudColor;
    SerializedProperty _rimColor;
    SerializedProperty _rimExponent;
    SerializedProperty _normalScale;
    SerializedProperty _nightLightColor;
    SerializedProperty _castShadows;
    SerializedProperty _receiveShadows;

    static GUIContent _textBaseSaturation = new GUIContent("Base Saturation");
    static GUIContent _textNightSideLight = new GUIContent("Night Side Light");

    void OnEnable()
    {
        _segments = serializedObject.FindProperty("_segments");
        _rings    = serializedObject.FindProperty("_rings");

        _colorSaturation = serializedObject.FindProperty("_colorSaturation");
        _seaColor        = serializedObject.FindProperty("_seaColor");
        _nightLightColor = serializedObject.FindProperty("_nightLightColor");

        _smoothness  = serializedObject.FindProperty("_smoothness");
        _normalScale = serializedObject.FindProperty("_normalScale");

        _cloudColor  = serializedObject.FindProperty("_cloudColor");
        _rimColor    = serializedObject.FindProperty("_rimColor");
        _rimExponent = serializedObject.FindProperty("_rimExponent");

        _castShadows    = serializedObject.FindProperty("_castShadows");
        _receiveShadows = serializedObject.FindProperty("_receiveShadows");
    }

    public override void OnInspectorGUI()
    {
        var instance = target as EarthRenderer;

        serializedObject.Update();

        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(_segments);
        EditorGUILayout.PropertyField(_rings);
        if (EditorGUI.EndChangeCheck()) instance.NotifyConfigChange();

        EditorGUILayout.Space();

        EditorGUILayout.LabelField("Atmosphere", EditorStyles.boldLabel);
        EditorGUILayout.PropertyField(_cloudColor);
        EditorGUILayout.PropertyField(_rimColor);
        EditorGUILayout.PropertyField(_rimExponent);

        EditorGUILayout.Space();

        EditorGUILayout.LabelField("Color Options", EditorStyles.boldLabel);
        EditorGUILayout.PropertyField(_colorSaturation, _textBaseSaturation);
        EditorGUILayout.PropertyField(_seaColor);
        EditorGUILayout.PropertyField(_nightLightColor, _textNightSideLight);

        EditorGUILayout.Space();

        EditorGUILayout.LabelField("Material", EditorStyles.boldLabel);
        EditorGUILayout.PropertyField(_smoothness);
        EditorGUILayout.PropertyField(_normalScale);

        EditorGUILayout.Space();

        EditorGUILayout.PropertyField(_castShadows);
        EditorGUILayout.PropertyField(_receiveShadows);

        serializedObject.ApplyModifiedProperties();
    }
}
