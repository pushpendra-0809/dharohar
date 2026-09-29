class_name FinalMasteryUI
extends CanvasLayer

signal mastery_completed()
signal ui_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var close_button: Button = $MainPanel/Header/CloseButton
@onready var title_label: Label = $MainPanel/Header/TitleLabel
@onready var subtitle_label: Label = $MainPanel/Header/SubtitleLabel

# ==============================================================================
# MATHEMATICS MASTERY (3-LEVEL SYSTEM)
# ==============================================================================
@onready var math_mastery_view: Control = $MainPanel/MathMasteryView
@onready var nav_container: HBoxContainer = $MainPanel/MathMasteryView/NavContainer
@onready var nav_buttons: Array[Button] = [
	$MainPanel/MathMasteryView/NavContainer/BtnNav0,
	$MainPanel/MathMasteryView/NavContainer/BtnNav1,
	$MainPanel/MathMasteryView/NavContainer/BtnNav2
]

@onready var level_panel: Panel = $MainPanel/MathMasteryView/LevelPanel
@onready var level_content: Control = $MainPanel/MathMasteryView/LevelPanel/LevelContent
@onready var level_title_label: Label = $MainPanel/MathMasteryView/LevelPanel/LevelContent/LevelHeader/LevelTitleLabel
@onready var level_progress_label: Label = $MainPanel/MathMasteryView/LevelPanel/LevelContent/LevelHeader/LevelProgressLabel
@onready var instructions_label: Label = $MainPanel/MathMasteryView/LevelPanel/LevelContent/InstructionsLabel
@onready var prompt_text: RichTextLabel = $MainPanel/MathMasteryView/LevelPanel/LevelContent/PromptText

@onready var workspace_card: Panel = $MainPanel/MathMasteryView/LevelPanel/LevelContent/WorkspaceCard
@onready var workspace_title: Label = $MainPanel/MathMasteryView/LevelPanel/LevelContent/WorkspaceCard/WorkspaceVBox/WorkspaceTitle
@onready var workspace_main: Label = $MainPanel/MathMasteryView/LevelPanel/LevelContent/WorkspaceCard/WorkspaceVBox/WorkspaceMain
@onready var workspace_sub: Label = $MainPanel/MathMasteryView/LevelPanel/LevelContent/WorkspaceCard/WorkspaceVBox/WorkspaceSub

@onready var math_option_buttons: Array[Button] = [
	$MainPanel/MathMasteryView/LevelPanel/LevelContent/OptionsGrid/Option0,
	$MainPanel/MathMasteryView/LevelPanel/LevelContent/OptionsGrid/Option1,
	$MainPanel/MathMasteryView/LevelPanel/LevelContent/OptionsGrid/Option2,
	$MainPanel/MathMasteryView/LevelPanel/LevelContent/OptionsGrid/Option3
]

@onready var math_feedback_view: Control = $MainPanel/MathMasteryView/LevelPanel/MathFeedbackView
@onready var status_label: Label = $MainPanel/MathMasteryView/LevelPanel/MathFeedbackView/FeedbackVBox/StatusLabel
@onready var feedback_msg: RichTextLabel = $MainPanel/MathMasteryView/LevelPanel/MathFeedbackView/FeedbackVBox/FeedbackMsg
@onready var explanation_box: RichTextLabel = $MainPanel/MathMasteryView/LevelPanel/MathFeedbackView/FeedbackVBox/ExplanationBox
@onready var btn_feedback_action: Button = $MainPanel/MathMasteryView/LevelPanel/MathFeedbackView/FeedbackVBox/BtnFeedbackAction

@onready var level_complete_view: Control = $MainPanel/MathMasteryView/LevelPanel/LevelCompleteView
@onready var lvl_comp_badge: Label = $MainPanel/MathMasteryView/LevelPanel/LevelCompleteView/LvlCompVBox/LvlCompBadge
@onready var lvl_comp_title: Label = $MainPanel/MathMasteryView/LevelPanel/LevelCompleteView/LvlCompVBox/LvlCompTitle
@onready var lvl_comp_quote: RichTextLabel = $MainPanel/MathMasteryView/LevelPanel/LevelCompleteView/LvlCompVBox/LvlCompQuote
@onready var btn_proceed_level: Button = $MainPanel/MathMasteryView/LevelPanel/LevelCompleteView/LvlCompVBox/BtnProceedLevel

@onready var math_completion_view: Control = $MainPanel/MathMasteryView/LevelPanel/MathCompletionView
@onready var comp_badge: Label = $MainPanel/MathMasteryView/LevelPanel/MathCompletionView/CompVBox/CompBadge
@onready var comp_title: Label = $MainPanel/MathMasteryView/LevelPanel/MathCompletionView/CompVBox/CompTitle
@onready var comp_quote: RichTextLabel = $MainPanel/MathMasteryView/LevelPanel/MathCompletionView/CompVBox/CompQuote
@onready var btn_conclude_mastery: Button = $MainPanel/MathMasteryView/LevelPanel/MathCompletionView/CompVBox/BtnConcludeMastery

# ==============================================================================
# ASTRONOMY MASTERY (3-LEVEL OBSERVATIONAL CHALLENGE)
# ==============================================================================
@onready var astro_mastery_view: Control = $MainPanel/AstroMasteryView
@onready var astro_nav_buttons: Array[Button] = [
	$MainPanel/AstroMasteryView/AstroNavContainer/BtnAstroNav0,
	$MainPanel/AstroMasteryView/AstroNavContainer/BtnAstroNav1,
	$MainPanel/AstroMasteryView/AstroNavContainer/BtnAstroNav2
]

@onready var astro_level_panel: Panel = $MainPanel/AstroMasteryView/AstroLevelPanel
@onready var astro_level_content: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent
@onready var astro_title_label: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/AstroHeader/AstroTitleLabel
@onready var astro_progress_label: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/AstroHeader/AstroProgressLabel
@onready var astro_instructions_label: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/AstroInstructionsLabel

# Level 1 Nodes
@onready var l1_container: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container
@onready var l1_sequencer_box: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox
@onready var l1_slot_buttons: Array[Button] = [
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SlotsRow/Slot0,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SlotsRow/Slot1,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SlotsRow/Slot2,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SlotsRow/Slot3,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SlotsRow/Slot4
]
@onready var l1_source_buttons: Array[Button] = [
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SourceTilesRow/Source0,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SourceTilesRow/Source1,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SourceTilesRow/Source2,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SourceTilesRow/Source3,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/SourceTilesRow/Source4
]
@onready var btn_verify_seq: Button = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1SequencerBox/BtnVerifySeq
@onready var l1_mini_obs_box: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1MiniObsBox
@onready var mini_obs_prompt: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1MiniObsBox/MiniObsCard/MiniObsPrompt
@onready var mini_opt_buttons: Array[Button] = [
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1MiniObsBox/MiniObsGrid/MiniOpt0,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1MiniObsBox/MiniObsGrid/MiniOpt1,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1MiniObsBox/MiniObsGrid/MiniOpt2,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L1Container/L1MiniObsBox/MiniObsGrid/MiniOpt3
]

# Level 2 Nodes
@onready var l2_container: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container
@onready var terrace_title: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container/TerraceCard/TerraceVBox/TerraceTitle
@onready var terrace_log_text: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container/TerraceCard/TerraceVBox/TerraceVisual
@onready var l2_choice_buttons: Array[Button] = [
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container/L2ChoicesGrid/L2Opt0,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container/L2ChoicesGrid/L2Opt1,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container/L2ChoicesGrid/L2Opt2,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L2Container/L2ChoicesGrid/L2Opt3
]

# Level 3 Nodes
@onready var l3_container: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container
@onready var notebook_context_text: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/FieldLogCard/FieldLogText
@onready var field_buttons: Array[OptionButton] = [
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/NotebookSlotsVBox/FieldRow0/FieldBtn0,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/NotebookSlotsVBox/FieldRow1/FieldBtn1,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/NotebookSlotsVBox/FieldRow2/FieldBtn2,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/NotebookSlotsVBox/FieldRow3/FieldBtn3,
	$MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/NotebookSlotsVBox/FieldRow4/FieldBtn4
]
@onready var btn_submit_final_obs: Button = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelContent/L3Container/BtnSubmitFinalObs

# Astronomy Feedback, Level Complete, and Completion Views
@onready var astro_feedback_view: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroFeedbackView
@onready var astro_status_label: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroFeedbackView/AstroFeedbackVBox/AstroStatusLabel
@onready var astro_feedback_msg: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroFeedbackView/AstroFeedbackVBox/AstroFeedbackMsg
@onready var astro_explanation_box: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroFeedbackView/AstroFeedbackVBox/AstroExplanationBox
@onready var btn_astro_feedback_action: Button = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroFeedbackView/AstroFeedbackVBox/BtnAstroFeedbackAction

@onready var astro_level_complete_view: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelCompleteView
@onready var astro_lvl_comp_badge: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelCompleteView/AstroLvlCompVBox/AstroLvlCompBadge
@onready var astro_lvl_comp_title: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelCompleteView/AstroLvlCompVBox/AstroLvlCompTitle
@onready var astro_lvl_comp_quote: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelCompleteView/AstroLvlCompVBox/AstroLvlCompQuote
@onready var btn_astro_proceed_level: Button = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroLevelCompleteView/AstroLvlCompVBox/BtnAstroProceedLevel

@onready var astro_completion_view: Control = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroCompletionView
@onready var astro_comp_badge: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroCompletionView/AstroCompVBox/AstroCompBadge
@onready var astro_comp_title: Label = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroCompletionView/AstroCompVBox/AstroCompTitle
@onready var astro_comp_quote: RichTextLabel = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroCompletionView/AstroCompVBox/AstroCompQuote
@onready var btn_astro_conclude_mastery: Button = $MainPanel/AstroMasteryView/AstroLevelPanel/AstroCompletionView/AstroCompVBox/BtnAstroConcludeMastery

# ==============================================================================
# MEDICINE MASTERY (3-LEVEL DIAGNOSTIC & FORMULATION CHALLENGE)
# ==============================================================================
@onready var med_mastery_view: Control = $MainPanel/MedMasteryView
@onready var med_nav_buttons: Array[Button] = [
	$MainPanel/MedMasteryView/MedNavContainer/BtnMedNav0,
	$MainPanel/MedMasteryView/MedNavContainer/BtnMedNav1,
	$MainPanel/MedMasteryView/MedNavContainer/BtnMedNav2
]

@onready var med_level_panel: Panel = $MainPanel/MedMasteryView/MedLevelPanel
@onready var med_level_content: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent
@onready var med_title_label: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedHeader/MedTitleLabel
@onready var med_progress_label: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedHeader/MedProgressLabel
@onready var med_instructions_label: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedInstructionsLabel

# Level 1 Nodes
@onready var med_l1_container: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container
@onready var patient_title: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/PatientCard/PatientVBox/PatientTitle
@onready var patient_desc_text: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/PatientCard/PatientVBox/PatientDescText
@onready var healers_notes_label: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/HealersNotesCard/HealersNotesLabel
@onready var symptom_buttons: Array[Button] = [
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/SymptomGrid/SymptomBtn0,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/SymptomGrid/SymptomBtn1,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/SymptomGrid/SymptomBtn2,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/SymptomGrid/SymptomBtn3,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/SymptomGrid/SymptomBtn4
]
@onready var btn_confirm_diagnosis: Button = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL1Container/BtnConfirmDiagnosis

# Level 2 Nodes
@onready var med_l2_container: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container
@onready var apothecary_title: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/ApothecaryCard/ApothecaryVBox/ApothecaryTitle
@onready var apothecary_goal_text: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/ApothecaryCard/ApothecaryVBox/ApothecaryGoalText
@onready var mortar_bowl_label: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/MortarBowlCard/MortarBowlLabel
@onready var herb_buttons: Array[Button] = [
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/HerbGrid/HerbBtn0,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/HerbGrid/HerbBtn1,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/HerbGrid/HerbBtn2,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/HerbGrid/HerbBtn3,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/HerbGrid/HerbBtn4
]
@onready var method_buttons: Array[Button] = [
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/MethodRow/MethodBtn0,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/MethodRow/MethodBtn1,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/MethodRow/MethodBtn2
]
@onready var btn_prepare_remedy: Button = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL2Container/BtnPrepareRemedy

# Level 3 Nodes
@onready var med_l3_container: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container
@onready var clinical_dossier_text: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/ClinicalDossierCard/ClinicalDossierText
@onready var med_field_buttons: Array[OptionButton] = [
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/ClinicalSlotsVBox/MedFieldRow0/MedFieldBtn0,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/ClinicalSlotsVBox/MedFieldRow1/MedFieldBtn1,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/ClinicalSlotsVBox/MedFieldRow2/MedFieldBtn2,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/ClinicalSlotsVBox/MedFieldRow3/MedFieldBtn3,
	$MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/ClinicalSlotsVBox/MedFieldRow4/MedFieldBtn4
]
@onready var btn_submit_final_prescription: Button = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelContent/MedL3Container/BtnSubmitFinalPrescription

# Medicine Feedback, Level Complete, and Completion Views
@onready var med_feedback_view: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedFeedbackView
@onready var med_status_label: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedFeedbackView/MedFeedbackVBox/MedStatusLabel
@onready var med_feedback_msg: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedFeedbackView/MedFeedbackVBox/MedFeedbackMsg
@onready var med_explanation_box: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedFeedbackView/MedFeedbackVBox/MedExplanationBox
@onready var btn_med_feedback_action: Button = $MainPanel/MedMasteryView/MedLevelPanel/MedFeedbackView/MedFeedbackVBox/BtnMedFeedbackAction

@onready var med_level_complete_view: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelCompleteView
@onready var med_lvl_comp_badge: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelCompleteView/MedLvlCompVBox/MedLvlCompBadge
@onready var med_lvl_comp_title: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelCompleteView/MedLvlCompVBox/MedLvlCompTitle
@onready var med_lvl_comp_quote: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelCompleteView/MedLvlCompVBox/MedLvlCompQuote
@onready var btn_med_proceed_level: Button = $MainPanel/MedMasteryView/MedLevelPanel/MedLevelCompleteView/MedLvlCompVBox/BtnMedProceedLevel

@onready var med_completion_view: Control = $MainPanel/MedMasteryView/MedLevelPanel/MedCompletionView
@onready var med_comp_badge: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedCompletionView/MedCompVBox/MedCompBadge
@onready var med_comp_title: Label = $MainPanel/MedMasteryView/MedLevelPanel/MedCompletionView/MedCompVBox/MedCompTitle
@onready var med_comp_quote: RichTextLabel = $MainPanel/MedMasteryView/MedLevelPanel/MedCompletionView/MedCompVBox/MedCompQuote
@onready var btn_med_conclude_mastery: Button = $MainPanel/MedMasteryView/MedLevelPanel/MedCompletionView/MedCompVBox/BtnMedConcludeMastery

# ==============================================================================
# PHILOSOPHY MASTERY (3-LEVEL ARGUMENT & DEBATE CHALLENGE)
# ==============================================================================
@onready var phil_mastery_view: Control = $MainPanel/PhilMasteryView
@onready var phil_nav_buttons: Array[Button] = [
	$MainPanel/PhilMasteryView/PhilNavContainer/BtnPhilNav0,
	$MainPanel/PhilMasteryView/PhilNavContainer/BtnPhilNav1,
	$MainPanel/PhilMasteryView/PhilNavContainer/BtnPhilNav2
]

@onready var phil_level_panel: Panel = $MainPanel/PhilMasteryView/PhilLevelPanel
@onready var phil_level_content: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent
@onready var phil_title_label: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilHeader/PhilTitleLabel
@onready var phil_progress_label: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilHeader/PhilProgressLabel
@onready var phil_instructions_label: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilInstructionsLabel

# Level 1 Nodes
@onready var phil_l1_container: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container
@onready var phil_l1_context_title: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1ContextCard/PhilL1ContextVBox/PhilL1ContextTitle
@onready var phil_l1_context_text: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1ContextCard/PhilL1ContextVBox/PhilL1ContextText
@onready var phil_l1_slot_buttons: Array[Button] = [
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1BoardPanel/PhilL1SlotsVBox/SlotRow0/SlotBtn0,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1BoardPanel/PhilL1SlotsVBox/SlotRow1/SlotBtn1,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1BoardPanel/PhilL1SlotsVBox/SlotRow2/SlotBtn2,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1BoardPanel/PhilL1SlotsVBox/SlotRow3/SlotBtn3
]
@onready var phil_l1_card_buttons: Array[Button] = [
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1CardsGrid/PhilL1Card0,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1CardsGrid/PhilL1Card1,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1CardsGrid/PhilL1Card2,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/PhilL1CardsGrid/PhilL1Card3
]
@onready var btn_phil_l1_verify: Button = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL1Container/BtnPhilL1Verify

# Level 2 Nodes
@onready var phil_l2_container: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container
@onready var phil_l2_debate_title: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2DebateCard/PhilL2DebateVBox/PhilL2DebateTitle
@onready var phil_l2_scholar_speech: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2DebateCard/PhilL2DebateVBox/PhilL2ScholarSpeech
@onready var phil_l2_weakness_buttons: Array[Button] = [
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2LensCard/PhilL2LensVBox/PhilL2WeaknessBtn0,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2LensCard/PhilL2LensVBox/PhilL2WeaknessBtn1,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2LensCard/PhilL2LensVBox/PhilL2WeaknessBtn2
]
@onready var phil_l2_response_buttons: Array[Button] = [
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2BuilderCard/PhilL2BuilderVBox/PhilL2ResponseBtn0,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2BuilderCard/PhilL2BuilderVBox/PhilL2ResponseBtn1,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/PhilL2BuilderCard/PhilL2BuilderVBox/PhilL2ResponseBtn2
]
@onready var btn_phil_l2_submit: Button = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL2Container/BtnPhilL2Submit

# Level 3 Nodes
@onready var phil_l3_container: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container
@onready var phil_l3_council_title: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/PhilL3DebateBoard/PhilL3DebateVBox/PhilL3CouncilTitle
@onready var phil_l3_opponent_speech: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/PhilL3DebateBoard/PhilL3DebateVBox/PhilL3OpponentSpeech
@onready var phil_l3_field_buttons: Array[OptionButton] = [
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/PhilL3SlotsVBox/PhilL3StepRow0/PhilL3Field0,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/PhilL3SlotsVBox/PhilL3StepRow1/PhilL3Field1,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/PhilL3SlotsVBox/PhilL3StepRow2/PhilL3Field2,
	$MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/PhilL3SlotsVBox/PhilL3StepRow3/PhilL3Field3
]
@onready var btn_phil_l3_submit: Button = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelContent/PhilL3Container/BtnPhilL3Submit

# Philosophy Feedback, Level Complete, and Completion Views
@onready var phil_feedback_view: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilFeedbackView
@onready var phil_status_label: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilFeedbackView/PhilFeedbackVBox/PhilStatusLabel
@onready var phil_feedback_msg: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilFeedbackView/PhilFeedbackVBox/PhilFeedbackMsg
@onready var phil_explanation_box: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilFeedbackView/PhilFeedbackVBox/PhilExplanationBox
@onready var btn_phil_feedback_action: Button = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilFeedbackView/PhilFeedbackVBox/BtnPhilFeedbackAction

@onready var phil_level_complete_view: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelCompleteView
@onready var phil_lvl_comp_badge: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelCompleteView/PhilLvlCompVBox/PhilLvlCompBadge
@onready var phil_lvl_comp_title: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelCompleteView/PhilLvlCompVBox/PhilLvlCompTitle
@onready var phil_lvl_comp_quote: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelCompleteView/PhilLvlCompVBox/PhilLvlCompQuote
@onready var btn_phil_proceed_level: Button = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilLevelCompleteView/PhilLvlCompVBox/BtnPhilProceedLevel

@onready var phil_completion_view: Control = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilCompletionView
@onready var phil_comp_badge: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilCompletionView/PhilCompVBox/PhilCompBadge
@onready var phil_comp_title: Label = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilCompletionView/PhilCompVBox/PhilCompTitle
@onready var phil_comp_quote: RichTextLabel = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilCompletionView/PhilCompVBox/PhilCompQuote
@onready var btn_phil_conclude_mastery: Button = $MainPanel/PhilMasteryView/PhilLevelPanel/PhilCompletionView/PhilCompVBox/BtnPhilConcludeMastery

# ==============================================================================
# CLASSIC TRIAL VIEW (FOR OTHER DOMAINS)
# ==============================================================================
@onready var trial_view: Control = $MainPanel/TrialView
@onready var narrative_text: RichTextLabel = $MainPanel/TrialView/NarrativeText
@onready var clues_text: RichTextLabel = $MainPanel/TrialView/CluesText
@onready var prompt_label: Label = $MainPanel/TrialView/PromptLabel
@onready var options_container: VBoxContainer = $MainPanel/TrialView/OptionsContainer
@onready var option_buttons: Array[Button] = [
	$MainPanel/TrialView/OptionsContainer/OptionA,
	$MainPanel/TrialView/OptionsContainer/OptionB,
	$MainPanel/TrialView/OptionsContainer/OptionC
]

@onready var feedback_view: Control = $MainPanel/FeedbackView
@onready var feedback_status: Label = $MainPanel/FeedbackView/FeedbackStatus
@onready var feedback_text: RichTextLabel = $MainPanel/FeedbackView/FeedbackText
@onready var explanation_text: RichTextLabel = $MainPanel/FeedbackView/ExplanationText
@onready var action_button: Button = $MainPanel/FeedbackView/BtnAction

# Styles
var style_nav_normal: StyleBoxFlat = null
var style_nav_active: StyleBoxFlat = null
var style_nav_done: StyleBoxFlat = null

# State
var is_open: bool = false
var active_domain: String = "mathematics"
var current_math_level_idx: int = 0
var current_task_idx: int = 0
var current_task_passed: bool = false
var current_l3_step: int = 1
var current_l3_problem: Dictionary = {}
var math_l2_hint_revealed: bool = false
var _on_complete_callback: Callable = Callable()

# Astronomy State
var current_astro_level_idx: int = 0
var astro_l1_placed_slots: Array = [-1, -1, -1, -1, -1]
var astro_l1_selected_source: int = -1
var astro_l1_scrambled_indices: Array[int] = [4, 0, 2, 3, 1]
var astro_l1_mini_obs_idx: int = 0
var astro_l2_sub_idx: int = 0
var current_astro_task_passed: bool = false

# Medicine State
var current_med_level_idx: int = 0
var med_l1_sub_idx: int = 0
var med_l1_selected_symptoms: Array[String] = []
var med_l2_sub_idx: int = 0
var med_l2_selected_herbs: Array[String] = []
var med_l2_selected_method: String = ""
var current_med_task_passed: bool = false

# Philosophy State
var current_phil_level_idx: int = 0
var phil_l1_sub_idx: int = 0
var phil_l1_placed_slots: Array[String] = ["", "", "", ""]
var phil_l1_selected_card_idx: int = -1
var phil_l2_sub_idx: int = 0
var phil_l2_selected_weakness_idx: int = -1
var phil_l2_selected_response_idx: int = -1
var current_phil_task_passed: bool = false

# Classic scenario state
var current_scenario: Dictionary = {}
var is_passed: bool = false

func _ready() -> void:
	add_to_group("final_mastery_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_styles()
	_setup_button_events()

func _setup_styles() -> void:
	if nav_buttons.size() > 0 and nav_buttons[0]:
		style_nav_normal = nav_buttons[0].get_theme_stylebox("normal") as StyleBoxFlat
	
	style_nav_active = StyleBoxFlat.new()
	style_nav_active.bg_color = Color(0.38, 0.26, 0.12, 0.98)
	style_nav_active.set_border_width_all(2)
	style_nav_active.border_color = Color(1.0, 0.88, 0.4, 1.0)
	style_nav_active.set_corner_radius_all(5)
	
	style_nav_done = StyleBoxFlat.new()
	style_nav_done.bg_color = Color(0.12, 0.22, 0.12, 0.95)
	style_nav_done.set_border_width_all(1)
	style_nav_done.border_color = Color(0.45, 0.9, 0.4, 0.9)
	style_nav_done.set_corner_radius_all(5)

func _setup_button_events() -> void:
	if close_button and not close_button.pressed.is_connected(close_ui):
		close_button.pressed.connect(close_ui)
		
	# Math Buttons
	for i in range(nav_buttons.size()):
		var btn: Button = nav_buttons[i]
		if btn and not btn.pressed.is_connected(_on_nav_button_pressed.bind(i)):
			btn.pressed.connect(_on_nav_button_pressed.bind(i))
			
	for i in range(math_option_buttons.size()):
		var btn: Button = math_option_buttons[i]
		if btn and not btn.pressed.is_connected(_on_math_option_selected.bind(i)):
			btn.pressed.connect(_on_math_option_selected.bind(i))
			
	if btn_feedback_action and not btn_feedback_action.pressed.is_connected(_on_feedback_action_pressed):
		btn_feedback_action.pressed.connect(_on_feedback_action_pressed)
		
	if btn_proceed_level and not btn_proceed_level.pressed.is_connected(_on_proceed_level_pressed):
		btn_proceed_level.pressed.connect(_on_proceed_level_pressed)
		
	if btn_conclude_mastery and not btn_conclude_mastery.pressed.is_connected(_on_conclude_mastery_pressed):
		btn_conclude_mastery.pressed.connect(_on_conclude_mastery_pressed)

	# Astronomy Nav Buttons
	for i in range(astro_nav_buttons.size()):
		var btn: Button = astro_nav_buttons[i]
		if btn and not btn.pressed.is_connected(_on_astro_nav_pressed.bind(i)):
			btn.pressed.connect(_on_astro_nav_pressed.bind(i))

	# Astronomy Level 1 Buttons
	for i in range(l1_slot_buttons.size()):
		var btn: Button = l1_slot_buttons[i]
		if btn and not btn.pressed.is_connected(_on_astro_l1_slot_clicked.bind(i)):
			btn.pressed.connect(_on_astro_l1_slot_clicked.bind(i))

	for i in range(l1_source_buttons.size()):
		var btn: Button = l1_source_buttons[i]
		if btn and not btn.pressed.is_connected(_on_astro_l1_source_clicked.bind(i)):
			btn.pressed.connect(_on_astro_l1_source_clicked.bind(i))

	if btn_verify_seq and not btn_verify_seq.pressed.is_connected(_on_astro_l1_verify_pressed):
		btn_verify_seq.pressed.connect(_on_astro_l1_verify_pressed)

	for i in range(mini_opt_buttons.size()):
		var btn: Button = mini_opt_buttons[i]
		if btn and not btn.pressed.is_connected(_on_astro_l1_mini_opt_selected.bind(i)):
			btn.pressed.connect(_on_astro_l1_mini_opt_selected.bind(i))

	# Astronomy Level 2 Buttons
	for i in range(l2_choice_buttons.size()):
		var btn: Button = l2_choice_buttons[i]
		if btn and not btn.pressed.is_connected(_on_astro_l2_choice_selected.bind(i)):
			btn.pressed.connect(_on_astro_l2_choice_selected.bind(i))

	# Astronomy Level 3 Buttons
	if btn_submit_final_obs and not btn_submit_final_obs.pressed.is_connected(_on_astro_l3_submit_pressed):
		btn_submit_final_obs.pressed.connect(_on_astro_l3_submit_pressed)

	# Astronomy Feedback & Completion Buttons
	if btn_astro_feedback_action and not btn_astro_feedback_action.pressed.is_connected(_on_astro_feedback_action_pressed):
		btn_astro_feedback_action.pressed.connect(_on_astro_feedback_action_pressed)
		
	if btn_astro_proceed_level and not btn_astro_proceed_level.pressed.is_connected(_on_astro_proceed_level_pressed):
		btn_astro_proceed_level.pressed.connect(_on_astro_proceed_level_pressed)
		
	if btn_astro_conclude_mastery and not btn_astro_conclude_mastery.pressed.is_connected(_on_conclude_astro_mastery_pressed):
		btn_astro_conclude_mastery.pressed.connect(_on_conclude_astro_mastery_pressed)

	# Medicine Nav Buttons
	for i in range(med_nav_buttons.size()):
		var btn: Button = med_nav_buttons[i]
		if btn and not btn.pressed.is_connected(_on_med_nav_pressed.bind(i)):
			btn.pressed.connect(_on_med_nav_pressed.bind(i))

	# Medicine Level 1 Buttons
	for i in range(symptom_buttons.size()):
		var btn: Button = symptom_buttons[i]
		if btn and not btn.pressed.is_connected(_on_med_l1_symptom_toggled.bind(i)):
			btn.pressed.connect(_on_med_l1_symptom_toggled.bind(i))

	if btn_confirm_diagnosis and not btn_confirm_diagnosis.pressed.is_connected(_on_med_l1_confirm_pressed):
		btn_confirm_diagnosis.pressed.connect(_on_med_l1_confirm_pressed)

	# Medicine Level 2 Buttons
	for i in range(herb_buttons.size()):
		var btn: Button = herb_buttons[i]
		if btn and not btn.pressed.is_connected(_on_med_l2_herb_toggled.bind(i)):
			btn.pressed.connect(_on_med_l2_herb_toggled.bind(i))

	for i in range(method_buttons.size()):
		var btn: Button = method_buttons[i]
		if btn and not btn.pressed.is_connected(_on_med_l2_method_selected.bind(i)):
			btn.pressed.connect(_on_med_l2_method_selected.bind(i))

	if btn_prepare_remedy and not btn_prepare_remedy.pressed.is_connected(_on_med_l2_prepare_pressed):
		btn_prepare_remedy.pressed.connect(_on_med_l2_prepare_pressed)

	# Medicine Level 3 Buttons
	if btn_submit_final_prescription and not btn_submit_final_prescription.pressed.is_connected(_on_med_l3_submit_pressed):
		btn_submit_final_prescription.pressed.connect(_on_med_l3_submit_pressed)

	# Medicine Feedback & Completion Buttons
	if btn_med_feedback_action and not btn_med_feedback_action.pressed.is_connected(_on_med_feedback_action_pressed):
		btn_med_feedback_action.pressed.connect(_on_med_feedback_action_pressed)

	if btn_med_proceed_level and not btn_med_proceed_level.pressed.is_connected(_on_med_proceed_level_pressed):
		btn_med_proceed_level.pressed.connect(_on_med_proceed_level_pressed)

	if btn_med_conclude_mastery and not btn_med_conclude_mastery.pressed.is_connected(_on_conclude_med_mastery_pressed):
		btn_med_conclude_mastery.pressed.connect(_on_conclude_med_mastery_pressed)

	# Philosophy Nav Buttons
	for i in range(phil_nav_buttons.size()):
		var btn: Button = phil_nav_buttons[i]
		if btn and not btn.pressed.is_connected(_on_phil_nav_pressed.bind(i)):
			btn.pressed.connect(_on_phil_nav_pressed.bind(i))

	# Philosophy Level 1 Buttons
	for i in range(phil_l1_slot_buttons.size()):
		var btn: Button = phil_l1_slot_buttons[i]
		if btn and not btn.pressed.is_connected(_on_phil_l1_slot_clicked.bind(i)):
			btn.pressed.connect(_on_phil_l1_slot_clicked.bind(i))

	for i in range(phil_l1_card_buttons.size()):
		var btn: Button = phil_l1_card_buttons[i]
		if btn and not btn.pressed.is_connected(_on_phil_l1_card_clicked.bind(i)):
			btn.pressed.connect(_on_phil_l1_card_clicked.bind(i))

	if btn_phil_l1_verify and not btn_phil_l1_verify.pressed.is_connected(_on_phil_l1_verify_pressed):
		btn_phil_l1_verify.pressed.connect(_on_phil_l1_verify_pressed)

	# Philosophy Level 2 Buttons
	for i in range(phil_l2_weakness_buttons.size()):
		var btn: Button = phil_l2_weakness_buttons[i]
		if btn and not btn.pressed.is_connected(_on_phil_l2_weakness_selected.bind(i)):
			btn.pressed.connect(_on_phil_l2_weakness_selected.bind(i))

	for i in range(phil_l2_response_buttons.size()):
		var btn: Button = phil_l2_response_buttons[i]
		if btn and not btn.pressed.is_connected(_on_phil_l2_response_selected.bind(i)):
			btn.pressed.connect(_on_phil_l2_response_selected.bind(i))

	if btn_phil_l2_submit and not btn_phil_l2_submit.pressed.is_connected(_on_phil_l2_submit_pressed):
		btn_phil_l2_submit.pressed.connect(_on_phil_l2_submit_pressed)

	# Philosophy Level 3 Buttons
	if btn_phil_l3_submit and not btn_phil_l3_submit.pressed.is_connected(_on_phil_l3_submit_pressed):
		btn_phil_l3_submit.pressed.connect(_on_phil_l3_submit_pressed)

	# Philosophy Feedback & Completion Buttons
	if btn_phil_feedback_action and not btn_phil_feedback_action.pressed.is_connected(_on_phil_feedback_action_pressed):
		btn_phil_feedback_action.pressed.connect(_on_phil_feedback_action_pressed)

	if btn_phil_proceed_level and not btn_phil_proceed_level.pressed.is_connected(_on_phil_proceed_level_pressed):
		btn_phil_proceed_level.pressed.connect(_on_phil_proceed_level_pressed)

	if btn_phil_conclude_mastery and not btn_phil_conclude_mastery.pressed.is_connected(_on_conclude_phil_mastery_pressed):
		btn_phil_conclude_mastery.pressed.connect(_on_conclude_phil_mastery_pressed)

	# Classic Buttons
	for i in range(option_buttons.size()):
		var btn: Button = option_buttons[i]
		if btn and not btn.pressed.is_connected(_on_classic_option_selected.bind(i)):
			btn.pressed.connect(_on_classic_option_selected.bind(i))
			
	if action_button and not action_button.pressed.is_connected(_on_classic_action_button_pressed):
		action_button.pressed.connect(_on_classic_action_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_ui()

func _get_canonical_domain(d: String) -> String:
	var d_lower: String = d.to_lower().strip_edges()
	if "math" in d_lower or "ganita" in d_lower or "gaṇita" in d_lower:
		return "mathematics"
	elif "astro" in d_lower or "jyotish" in d_lower or "jyotiṣa" in d_lower or "jyotisha" in d_lower:
		return "astronomy"
	elif "med" in d_lower or "ayur" in d_lower or "āyur" in d_lower or "cikits" in d_lower:
		return "medicine"
	elif "phil" in d_lower or "darśan" in d_lower or "darshan" in d_lower or "nyay" in d_lower or "nyāy" in d_lower:
		return "philosophy"
	return d_lower

func open_ui(on_complete: Callable = Callable(), target_level_idx: int = -1) -> void:
	_on_complete_callback = on_complete
	var raw_domain: String = GameState.selected_domain if GameState else "mathematics"
	if raw_domain == "":
		raw_domain = "mathematics"
	active_domain = _get_canonical_domain(raw_domain)
	
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		
	if active_domain == "mathematics":
		if math_mastery_view:
			math_mastery_view.visible = true
		if astro_mastery_view:
			astro_mastery_view.visible = false
		if med_mastery_view:
			med_mastery_view.visible = false
		if phil_mastery_view:
			phil_mastery_view.visible = false
		if trial_view:
			trial_view.visible = false
		if feedback_view:
			feedback_view.visible = false
		_setup_math_mastery(target_level_idx)
	elif active_domain == "astronomy":
		if math_mastery_view:
			math_mastery_view.visible = false
		if astro_mastery_view:
			astro_mastery_view.visible = true
		if med_mastery_view:
			med_mastery_view.visible = false
		if phil_mastery_view:
			phil_mastery_view.visible = false
		if trial_view:
			trial_view.visible = false
		if feedback_view:
			feedback_view.visible = false
		_setup_astronomy_mastery(target_level_idx)
	elif active_domain == "medicine":
		if math_mastery_view:
			math_mastery_view.visible = false
		if astro_mastery_view:
			astro_mastery_view.visible = false
		if med_mastery_view:
			med_mastery_view.visible = true
		if phil_mastery_view:
			phil_mastery_view.visible = false
		if trial_view:
			trial_view.visible = false
		if feedback_view:
			feedback_view.visible = false
		_setup_medicine_mastery(target_level_idx)
	elif active_domain == "philosophy":
		if math_mastery_view:
			math_mastery_view.visible = false
		if astro_mastery_view:
			astro_mastery_view.visible = false
		if med_mastery_view:
			med_mastery_view.visible = false
		if phil_mastery_view:
			phil_mastery_view.visible = true
		if trial_view:
			trial_view.visible = false
		if feedback_view:
			feedback_view.visible = false
		_setup_philosophy_mastery(target_level_idx)
	else:
		if math_mastery_view:
			math_mastery_view.visible = false
		if astro_mastery_view:
			astro_mastery_view.visible = false
		if med_mastery_view:
			med_mastery_view.visible = false
		if phil_mastery_view:
			phil_mastery_view.visible = false
		if trial_view:
			trial_view.visible = true
		if feedback_view:
			feedback_view.visible = false
		_setup_classic_scenario()

# ==============================================================================
# MATHEMATICS MASTERY IMPLEMENTATION
# ==============================================================================
func _setup_math_mastery(forced_level_idx: int = -1) -> void:
	if title_label:
		title_label.text = "MATHEMATICS MASTERY"
	if subtitle_label:
		subtitle_label.text = "THE SCHOLAR'S TRIAL — FINAL MASTERY OF GANITA"
		
	if forced_level_idx >= 0 and forced_level_idx < MathematicsMasteryData.get_level_count():
		current_math_level_idx = forced_level_idx
	else:
		current_math_level_idx = 0
		for i in range(MathematicsMasteryData.get_level_count()):
			var lvl_data: Dictionary = MathematicsMasteryData.get_level(i)
			var lvl_id: String = str(lvl_data.get("id", ""))
			if GameState and not GameState.is_math_mastery_stage_complete(lvl_id):
				current_math_level_idx = i
				break
				
	_load_math_level(current_math_level_idx)

func _update_math_nav_bar() -> void:
	for i in range(nav_buttons.size()):
		var btn: Button = nav_buttons[i]
		if not btn:
			continue
			
		var lvl_data: Dictionary = MathematicsMasteryData.get_level(i)
		var l_id: String = str(lvl_data.get("id", ""))
		var nav_label: String = str(lvl_data.get("nav_label", "[ " + str(i + 1) + " ] LEVEL"))
		
		var is_complete: bool = GameState.is_math_mastery_stage_complete(l_id) if GameState else false
		var is_unlocked: bool = GameState.is_math_mastery_stage_unlocked(l_id) if GameState else (i == 0)
		var is_current: bool = (i == current_math_level_idx)
		
		if is_complete:
			btn.text = "✓ " + nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(0.5, 1.0, 0.4, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else (style_nav_done if style_nav_done else style_nav_normal))
		elif is_unlocked:
			btn.text = nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else style_nav_normal)
		else:
			btn.text = "🔒 " + nav_label
			btn.disabled = true
			btn.add_theme_color_override("font_color", Color(0.55, 0.5, 0.45, 0.7))
			btn.add_theme_stylebox_override("normal", style_nav_normal)

func _load_math_level(level_idx: int) -> void:
	current_math_level_idx = level_idx
	current_task_idx = 0
	current_task_passed = false
	current_l3_step = 1
	
	_update_math_nav_bar()
	
	if math_feedback_view:
		math_feedback_view.visible = false
	if level_complete_view:
		level_complete_view.visible = false
	if math_completion_view:
		math_completion_view.visible = false
	if level_content:
		level_content.visible = true
		
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(level_idx)
	if lvl_data.is_empty():
		return
		
	if level_title_label:
		level_title_label.text = ("LEVEL " + str(level_idx + 1) + ": " + str(lvl_data.get("title", ""))).to_upper()
	if instructions_label:
		instructions_label.text = str(lvl_data.get("instructions", ""))
		
	if level_idx == 0:
		_load_level_1_task(0)
	elif level_idx == 1:
		_load_level_2_task(0)
	elif level_idx == 2:
		_load_level_3_task()

func _load_level_1_task(task_idx: int) -> void:
	current_task_idx = task_idx
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(0)
	var tasks: Array = lvl_data.get("tasks", [])
	if task_idx < 0 or task_idx >= tasks.size():
		return
		
	var task: Dictionary = tasks[task_idx]
	if level_progress_label:
		level_progress_label.text = "Sequence " + str(task_idx + 1) + " of " + str(tasks.size())
	if prompt_text:
		prompt_text.text = "[b]Task " + str(task_idx + 1) + ":[/b] " + str(task.get("prompt", ""))
		
	if workspace_card:
		workspace_card.visible = true
		workspace_card.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if workspace_title:
		workspace_title.text = "SEQUENCE BOARD"
		workspace_title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
	if workspace_main:
		workspace_main.text = str(task.get("sequence_display", ""))
		workspace_main.add_theme_color_override("font_color", Color(1.0, 0.95, 0.8))
	if workspace_sub:
		workspace_sub.text = "Rule: " + str(task.get("rule_hint", task.get("rule_description", "")))
		workspace_sub.add_theme_color_override("font_color", Color(0.85, 0.8, 0.7))
		
	var options: Array = task.get("options", [])
	for i in range(math_option_buttons.size()):
		var btn: Button = math_option_buttons[i]
		if i < options.size():
			btn.text = str(options[i])
			btn.visible = true
			btn.disabled = false
		else:
			btn.visible = false

func _load_level_2_task(task_idx: int) -> void:
	current_task_idx = task_idx
	math_l2_hint_revealed = false
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(1)
	var tasks: Array = lvl_data.get("tasks", [])
	if task_idx < 0 or task_idx >= tasks.size():
		return
		
	var task: Dictionary = tasks[task_idx]
	if level_progress_label:
		level_progress_label.text = "Problem " + str(task_idx + 1) + " of " + str(tasks.size())
	if prompt_text:
		prompt_text.text = "[b]" + str(task.get("context_title", "Practical Calculation")) + ":[/b]\n" + str(task.get("prompt", ""))
		
	if workspace_card:
		workspace_card.visible = true
		workspace_card.mouse_filter = Control.MOUSE_FILTER_STOP
		workspace_card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		if not workspace_card.gui_input.is_connected(_on_workspace_card_gui_input):
			workspace_card.gui_input.connect(_on_workspace_card_gui_input)
			
	_update_math_l2_hint_display()
		
	var options: Array = task.get("options", [])
	for i in range(math_option_buttons.size()):
		var btn: Button = math_option_buttons[i]
		if i < options.size():
			btn.text = str(options[i])
			btn.visible = true
			btn.disabled = false
		else:
			btn.visible = false

func _on_workspace_card_gui_input(event: InputEvent) -> void:
	if active_domain == "mathematics" and current_math_level_idx == 1:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_toggle_math_l2_hint()

func _toggle_math_l2_hint() -> void:
	math_l2_hint_revealed = not math_l2_hint_revealed
	_update_math_l2_hint_display()

func _update_math_l2_hint_display() -> void:
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(1)
	var tasks: Array = lvl_data.get("tasks", [])
	if current_task_idx < 0 or current_task_idx >= tasks.size():
		return
	var task: Dictionary = tasks[current_task_idx]
	
	if workspace_title:
		if math_l2_hint_revealed:
			workspace_title.text = "💡 ALGEBRAIC HINT & OPERATION [CLICK TO HIDE]"
			workspace_title.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4))
		else:
			workspace_title.text = "💡 HINT [CLICK TO REVEAL ALGEBRAIC OPERATION]"
			workspace_title.add_theme_color_override("font_color", Color(0.95, 0.8, 0.35))
			
	if workspace_main:
		if math_l2_hint_revealed:
			workspace_main.text = str(task.get("algebraic_operation", task.get("ledger_formula", "")))
			workspace_main.add_theme_color_override("font_color", Color(0.45, 1.0, 0.55))
		else:
			workspace_main.text = "▶ Click to show algebraic formulation & step-by-step operation"
			workspace_main.add_theme_color_override("font_color", Color(0.85, 0.8, 0.7))
			
	if workspace_sub:
		if math_l2_hint_revealed:
			workspace_sub.text = str(task.get("algebraic_formula", task.get("hint", "")))
			workspace_sub.add_theme_color_override("font_color", Color(1.0, 0.92, 0.65))
		else:
			workspace_sub.text = str(task.get("ledger_data", ""))
			workspace_sub.add_theme_color_override("font_color", Color(0.75, 0.7, 0.65))

func _load_level_3_task() -> void:
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(2)
	var pool: Array = lvl_data.get("problem_pool", [])
	if pool.size() > 0:
		current_l3_problem = pool[0]
	else:
		current_l3_problem = {}
	current_l3_step = 1
	_load_level_3_step(1)

func _load_level_3_step(step_idx: int) -> void:
	current_l3_step = step_idx
	var step_key: String = "step" + str(step_idx)
	var step_data: Dictionary = current_l3_problem.get(step_key, {})
	if step_data.is_empty():
		return
		
	if level_progress_label:
		level_progress_label.text = "Grand Problem: Step " + str(step_idx) + " of 2"
		
	var prob_title: String = str(current_l3_problem.get("title", "Nalanda Logistics Problem"))
	var prob_context: String = str(current_l3_problem.get("context", ""))
	var step_prompt: String = str(step_data.get("prompt", ""))
	var step_title: String = str(step_data.get("title", "Step " + str(step_idx)))
	if prompt_text:
		prompt_text.text = "[b]" + prob_title + "[/b]\n" + prob_context + "\n\n[b]" + step_title + ":[/b]\n" + step_prompt
		
	if workspace_card:
		workspace_card.visible = true
		workspace_card.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if workspace_title:
		workspace_title.text = "EQUATION / FORMULA WORKSPACE"
		workspace_title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
	if workspace_main:
		workspace_main.text = str(step_data.get("formula_display", ""))
		workspace_main.add_theme_color_override("font_color", Color(1.0, 0.95, 0.8))
	if workspace_sub:
		workspace_sub.text = "Goal: " + str(current_l3_problem.get("target_question", ""))
		workspace_sub.add_theme_color_override("font_color", Color(0.85, 0.8, 0.7))
		
	var options: Array = step_data.get("options", [])
	for i in range(math_option_buttons.size()):
		var btn: Button = math_option_buttons[i]
		if i < options.size():
			btn.text = str(options[i])
			btn.visible = true
			btn.disabled = false
		else:
			btn.visible = false

func _on_math_option_selected(index: int) -> void:
	if current_math_level_idx == 0:
		_evaluate_level_1_choice(index)
	elif current_math_level_idx == 1:
		_evaluate_level_2_choice(index)
	elif current_math_level_idx == 2:
		_evaluate_level_3_choice(index)

func _evaluate_level_1_choice(index: int) -> void:
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(0)
	var task: Dictionary = lvl_data.get("tasks", [])[current_task_idx]
	var correct_idx: int = int(task.get("correct", 0))
	var is_correct: bool = (index == correct_idx)
	
	current_task_passed = is_correct
	var feedback: String = "Correct! The sequence is correctly completed." if is_correct else "Incorrect tile chosen."
	var explanation_str: String = str(task.get("explanation", ""))
	
	_show_math_feedback(is_correct, feedback, explanation_str)

func _evaluate_level_2_choice(index: int) -> void:
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(1)
	var task: Dictionary = lvl_data.get("tasks", [])[current_task_idx]
	var correct_idx: int = int(task.get("correct", 0))
	var is_correct: bool = (index == correct_idx)
	
	current_task_passed = is_correct
	var feedback: String = "Accurate calculation!" if is_correct else "Calculation discrepancy found."
	var explanation_str: String = str(task.get("explanation", ""))
	
	_show_math_feedback(is_correct, feedback, explanation_str)

func _evaluate_level_3_choice(index: int) -> void:
	var step_key: String = "step" + str(current_l3_step)
	var step_data: Dictionary = current_l3_problem.get(step_key, {})
	var correct_idx: int = int(step_data.get("correct", 0))
	var is_correct: bool = (index == correct_idx)
	
	current_task_passed = is_correct
	var feedback: String = "Step " + str(current_l3_step) + " verified accurately!" if is_correct else "Flaw detected in Step " + str(current_l3_step) + " calculation."
	var explanation_str: String = str(step_data.get("explanation", ""))
	
	_show_math_feedback(is_correct, feedback, explanation_str)

func _show_math_feedback(is_correct: bool, feedback_text_content: String, explanation: String) -> void:
	if level_content:
		level_content.visible = false
	if math_feedback_view:
		math_feedback_view.visible = true
		
	if is_correct:
		if status_label:
			status_label.text = "★ CALCULATION VERIFIED ★"
			status_label.modulate = Color(0.4, 1.0, 0.4, 1.0)
		if feedback_msg:
			feedback_msg.text = "[center][b][color=#55ff55]" + feedback_text_content + "[/color][/b][/center]"
		if explanation_box:
			explanation_box.text = "[b]Scholarly Explanation:[/b]\n" + explanation
		if btn_feedback_action:
			btn_feedback_action.text = "Proceed ➔"
			btn_feedback_action.modulate = Color(1.0, 0.92, 0.7, 1.0)
	else:
		if status_label:
			status_label.text = "CALCULATION ERROR DETECTED"
			status_label.modulate = Color(1.0, 0.35, 0.35, 1.0)
		if feedback_msg:
			feedback_msg.text = "[center][b][color=#ff6666]" + feedback_text_content + "[/color][/b][/center]"
		if explanation_box:
			explanation_box.text = "[b]Mathematical Insight:[/b]\n" + explanation + "\n\n[i]Rethink the numbers and try again.[/i]"
		if btn_feedback_action:
			btn_feedback_action.text = "🔄 Try Again"
			btn_feedback_action.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_feedback_action_pressed() -> void:
	if current_task_passed:
		if current_math_level_idx == 0:
			var total_tasks: int = MathematicsMasteryData.get_level(0).get("tasks", []).size()
			if current_task_idx + 1 < total_tasks:
				if math_feedback_view:
					math_feedback_view.visible = false
				if level_content:
					level_content.visible = true
				_load_level_1_task(current_task_idx + 1)
			else:
				_complete_math_level(0)
		elif current_math_level_idx == 1:
			var total_tasks: int = MathematicsMasteryData.get_level(1).get("tasks", []).size()
			if current_task_idx + 1 < total_tasks:
				if math_feedback_view:
					math_feedback_view.visible = false
				if level_content:
					level_content.visible = true
				_load_level_2_task(current_task_idx + 1)
			else:
				_complete_math_level(1)
		elif current_math_level_idx == 2:
			var total_steps: int = 2
			if current_l3_step < total_steps:
				if math_feedback_view:
					math_feedback_view.visible = false
				if level_content:
					level_content.visible = true
				_load_level_3_step(current_l3_step + 1)
			else:
				_complete_math_level(2)
	else:
		if math_feedback_view:
			math_feedback_view.visible = false
		if level_content:
			level_content.visible = true

func _complete_math_level(level_idx: int) -> void:
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(level_idx)
	var lvl_id: String = str(lvl_data.get("id", ""))
	if GameState:
		GameState.complete_math_mastery_stage(lvl_id)
		
	_update_math_nav_bar()
	
	if level_idx < 2:
		_show_level_complete_screen(level_idx)
	else:
		_show_math_final_completion_screen()

func _show_level_complete_screen(level_idx: int) -> void:
	if level_content:
		level_content.visible = false
	if math_feedback_view:
		math_feedback_view.visible = false
	if level_complete_view:
		level_complete_view.visible = true
		
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(level_idx)
	var next_lvl_data: Dictionary = MathematicsMasteryData.get_level(level_idx + 1)
	
	if lvl_comp_badge:
		lvl_comp_badge.text = "★ LEVEL " + str(level_idx + 1) + " COMPLETE ★"
	if lvl_comp_title:
		lvl_comp_title.text = str(lvl_data.get("title", "")).to_upper() + " MASTERED"
	if lvl_comp_quote:
		lvl_comp_quote.text = "[center][color=#ffdd88]\"" + str(lvl_data.get("complete_quote", "")) + "\"[/color][/center]"
	if btn_proceed_level:
		btn_proceed_level.text = "Unlock & Begin Level " + str(level_idx + 2) + ": " + str(next_lvl_data.get("title", "")) + " ➔"

func _on_proceed_level_pressed() -> void:
	if current_math_level_idx < 2:
		_load_math_level(current_math_level_idx + 1)

func _on_nav_button_pressed(index: int) -> void:
	var lvl_data: Dictionary = MathematicsMasteryData.get_level(index)
	var l_id: String = str(lvl_data.get("id", ""))
	if GameState and GameState.is_math_mastery_stage_unlocked(l_id):
		_load_math_level(index)

func _show_math_final_completion_screen() -> void:
	if level_content:
		level_content.visible = false
	if math_feedback_view:
		math_feedback_view.visible = false
	if level_complete_view:
		level_complete_view.visible = false
	if math_completion_view:
		math_completion_view.visible = true
		
	if comp_badge:
		comp_badge.text = "🏆 MATHEMATICS MASTERY COMPLETE 🏆"
	if comp_title:
		comp_title.text = "SCHOLAR OF GANITA — LIVING HERITAGE OF NALANDA"
	if comp_quote:
		comp_quote.text = "[center][color=#ffdd88]\"You did not simply remember numbers.\n\nYou understood them, calculated with precision, and resolved a living challenge of Nalanda.\n\nThat is the beginning of true mastery.\"[/color][/center]"

func _on_conclude_mastery_pressed() -> void:
	if GameState:
		GameState.complete_math_mastery()
	mastery_completed.emit()
	var cb: Callable = _on_complete_callback
	close_ui()
	if cb.is_valid():
		cb.call()
	else:
		_trigger_fallback_completion_flow()

# ==============================================================================
# ASTRONOMY MASTERY IMPLEMENTATION
# ==============================================================================
func _setup_astronomy_mastery(forced_level_idx: int = -1) -> void:
	if title_label:
		title_label.text = "ASTRONOMY MASTERY"
	if subtitle_label:
		subtitle_label.text = "THE SKY OBSERVER — FINAL MASTERY OF JYOTISHA"
		
	if forced_level_idx >= 0 and forced_level_idx < AstronomyMasteryData.get_level_count():
		current_astro_level_idx = forced_level_idx
	else:
		current_astro_level_idx = 0
		for i in range(AstronomyMasteryData.get_level_count()):
			var lvl_data: Dictionary = AstronomyMasteryData.get_level(i)
			var lvl_id: String = str(lvl_data.get("id", ""))
			if GameState and not GameState.is_astro_mastery_stage_complete(lvl_id):
				current_astro_level_idx = i
				break
				
	_load_astro_level(current_astro_level_idx)

func _update_astro_nav_bar() -> void:
	for i in range(astro_nav_buttons.size()):
		var btn: Button = astro_nav_buttons[i]
		if not btn:
			continue
			
		var lvl_data: Dictionary = AstronomyMasteryData.get_level(i)
		var l_id: String = str(lvl_data.get("id", ""))
		var nav_label: String = str(lvl_data.get("nav_label", "[ " + str(i + 1) + " ] LEVEL"))
		
		var is_complete: bool = GameState.is_astro_mastery_stage_complete(l_id) if GameState else false
		var is_unlocked: bool = GameState.is_astro_mastery_stage_unlocked(l_id) if GameState else (i == 0)
		var is_current: bool = (i == current_astro_level_idx)
		
		if is_complete:
			btn.text = "✓ " + nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(0.5, 1.0, 0.4, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else (style_nav_done if style_nav_done else style_nav_normal))
		elif is_unlocked:
			btn.text = nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else style_nav_normal)
		else:
			btn.text = "🔒 " + nav_label
			btn.disabled = true
			btn.add_theme_color_override("font_color", Color(0.55, 0.5, 0.45, 0.7))
			btn.add_theme_stylebox_override("normal", style_nav_normal)

func _load_astro_level(level_idx: int) -> void:
	current_astro_level_idx = level_idx
	current_astro_task_passed = false
	
	_update_astro_nav_bar()
	
	if astro_feedback_view:
		astro_feedback_view.visible = false
	if astro_level_complete_view:
		astro_level_complete_view.visible = false
	if astro_completion_view:
		astro_completion_view.visible = false
	if astro_level_content:
		astro_level_content.visible = true
		
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(level_idx)
	if lvl_data.is_empty():
		return
		
	if astro_title_label:
		astro_title_label.text = ("LEVEL " + str(level_idx + 1) + ": " + str(lvl_data.get("title", ""))).to_upper()
	if astro_instructions_label:
		astro_instructions_label.text = str(lvl_data.get("instructions", ""))
		
	if level_idx == 0:
		_setup_astro_level_1()
	elif level_idx == 1:
		_setup_astro_level_2()
	elif level_idx == 2:
		_setup_astro_level_3()

# Astro Level 1
func _setup_astro_level_1() -> void:
	if l1_container:
		l1_container.visible = true
	if l2_container:
		l2_container.visible = false
	if l3_container:
		l3_container.visible = false
		
	astro_l1_placed_slots = [-1, -1, -1, -1, -1]
	astro_l1_selected_source = -1
	astro_l1_mini_obs_idx = 0
	
	if astro_progress_label:
		astro_progress_label.text = "Part 1: Moon Phase Sequence"
		
	if l1_sequencer_box:
		l1_sequencer_box.visible = true
	if l1_mini_obs_box:
		l1_mini_obs_box.visible = false
		
	_update_astro_l1_source_buttons()
	_update_astro_l1_slots_ui()

func _update_astro_l1_source_buttons() -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(0)
	var tiles: Array = lvl_data.get("phase_sequence", lvl_data.get("phase_tiles", []))
	for i in range(l1_source_buttons.size()):
		var btn: Button = l1_source_buttons[i]
		if not btn:
			continue
		if i < astro_l1_scrambled_indices.size() and i < tiles.size():
			var p_idx: int = astro_l1_scrambled_indices[i]
			var p: Dictionary = tiles[p_idx]
			var is_placed: bool = astro_l1_placed_slots.has(p_idx)
			var is_selected: bool = (astro_l1_selected_source == i)
			
			btn.text = str(p.get("symbol", "")) + " " + str(p.get("name", ""))
			btn.visible = true
			btn.disabled = false
			if is_selected:
				btn.modulate = Color(1.0, 0.85, 0.3, 1.0)
			elif is_placed:
				btn.modulate = Color(0.45, 0.45, 0.45, 0.7)
			else:
				btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			btn.visible = false

func _update_astro_l1_slots_ui() -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(0)
	var tiles: Array = lvl_data.get("phase_sequence", lvl_data.get("phase_tiles", []))
	for i in range(l1_slot_buttons.size()):
		var btn: Button = l1_slot_buttons[i]
		if not btn:
			continue
		var p_idx: int = int(astro_l1_placed_slots[i])
		if p_idx >= 0 and p_idx < tiles.size():
			var p: Dictionary = tiles[p_idx]
			btn.text = "Slot " + str(i + 1) + "\n" + str(p.get("symbol", "")) + " " + str(p.get("name", ""))
			btn.modulate = Color(1.0, 0.9, 0.5, 1.0)
		else:
			btn.text = "Slot " + str(i + 1) + "\n[ Empty ]"
			btn.modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_astro_l1_source_clicked(index: int) -> void:
	if astro_l1_selected_source == index:
		astro_l1_selected_source = -1
	else:
		astro_l1_selected_source = index
	_update_astro_l1_source_buttons()

func _on_astro_l1_slot_clicked(slot_idx: int) -> void:
	if astro_l1_selected_source >= 0:
		var p_idx: int = astro_l1_scrambled_indices[astro_l1_selected_source]
		for i in range(astro_l1_placed_slots.size()):
			if astro_l1_placed_slots[i] == p_idx:
				astro_l1_placed_slots[i] = -1
		astro_l1_placed_slots[slot_idx] = p_idx
		astro_l1_selected_source = -1
		_update_astro_l1_source_buttons()
		_update_astro_l1_slots_ui()
	else:
		if astro_l1_placed_slots[slot_idx] >= 0:
			astro_l1_placed_slots[slot_idx] = -1
			_update_astro_l1_source_buttons()
			_update_astro_l1_slots_ui()

func _on_astro_l1_verify_pressed() -> void:
	for slot_val in astro_l1_placed_slots:
		if slot_val == -1:
			_show_astro_feedback(false, "Incomplete Sequence", "Please place all 5 lunar phases into the order slots before verifying.")
			return
			
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(0)
	var tiles: Array = lvl_data.get("phase_sequence", lvl_data.get("phase_tiles", []))
	var is_correct: bool = true
	for i in range(astro_l1_placed_slots.size()):
		var t_idx: int = int(astro_l1_placed_slots[i])
		var correct_order: int = int(tiles[t_idx].get("order_index", tiles[t_idx].get("correct_order", t_idx)))
		if correct_order != i:
			is_correct = false
			break
			
	current_astro_task_passed = is_correct
	var fb: String = "Accurate lunar waxing sequence! The progression from New Moon (Amavasya) to Full Moon (Purnima) is correctly restored." if is_correct else "Incorrect lunar phase progression. Follow the Moon's natural waxing journey from dark (🌑) to illumination (🌕)."
	var explanation_str: String = "The lunar waxing fortnight (Shukla Paksha) progresses naturally: New Moon (Amavasya 🌑) ➔ Waxing Crescent (Shukla Dvitiya 🌒) ➔ First Quarter (Ardha Chandra 🌓) ➔ Waxing Gibbous (Shukla Trayodashi 🌔) ➔ Full Moon (Purnima 🌕)."
	
	_show_astro_feedback(is_correct, fb, explanation_str)

func _load_astro_l1_mini_obs(obs_idx: int) -> void:
	astro_l1_mini_obs_idx = obs_idx
	if l1_sequencer_box:
		l1_sequencer_box.visible = false
	if l1_mini_obs_box:
		l1_mini_obs_box.visible = true
		
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(0)
	var obs_list: Array = lvl_data.get("mini_observations", [])
	if obs_idx < 0 or obs_idx >= obs_list.size():
		return
		
	var obs: Dictionary = obs_list[obs_idx]
	if astro_progress_label:
		astro_progress_label.text = "Part 2: Mini Observation " + str(obs_idx + 1) + " of " + str(obs_list.size())
		
	if mini_obs_prompt:
		mini_obs_prompt.text = "[b]Sky Observation:[/b]\n" + str(obs.get("prompt", ""))
		
	var options: Array = obs.get("options", [])
	for i in range(mini_opt_buttons.size()):
		var btn: Button = mini_opt_buttons[i]
		if not btn:
			continue
		if i < options.size():
			btn.text = str(options[i])
			btn.visible = true
			btn.disabled = false
		else:
			btn.visible = false

func _on_astro_l1_mini_opt_selected(index: int) -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(0)
	var obs: Dictionary = lvl_data.get("mini_observations", [])[astro_l1_mini_obs_idx]
	var is_correct: bool = (index == int(obs.get("correct", 0)))
	
	current_astro_task_passed = is_correct
	var fb: String = "Precise celestial deduction!" if is_correct else "Observation deduction discrepancy."
	var explanation_str: String = str(obs.get("explanation", ""))
	
	_show_astro_feedback(is_correct, fb, explanation_str)

# Astro Level 2
func _setup_astro_level_2() -> void:
	if l1_container:
		l1_container.visible = false
	if l2_container:
		l2_container.visible = true
	if l3_container:
		l3_container.visible = false
		
	astro_l2_sub_idx = 0
	_load_astro_level_2_task(0)

func _load_astro_level_2_task(task_idx: int) -> void:
	astro_l2_sub_idx = task_idx
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(1)
	var tasks: Array = lvl_data.get("challenges", lvl_data.get("scenarios", []))
	if task_idx < 0 or task_idx >= tasks.size():
		return
		
	var t: Dictionary = tasks[task_idx]
	if astro_progress_label:
		astro_progress_label.text = "Observation Log " + str(task_idx + 1) + " of " + str(tasks.size())
		
	if terrace_title:
		terrace_title.text = "OBSERVATION LOG: " + str(t.get("sub_title", t.get("title", ""))).to_upper()
	if terrace_log_text:
		var body_text: String = ""
		if t.has("instructions"):
			body_text += "[b]Instructions:[/b]\n" + str(t.get("instructions", "")) + "\n\n"
		if t.has("horizon_view"):
			body_text += "[b]Terrace Observation Board:[/b]\n[center]" + str(t.get("horizon_view", "")) + "[/center]\n"
		elif t.has("target_diagram"):
			body_text += "[b]Sighting Tube Target (" + str(t.get("target_pattern_name", "")) + "):[/b]\n[code]" + str(t.get("target_diagram", "")) + "[/code]\n"
		elif t.has("sky_grid_title"):
			body_text += "[b]" + str(t.get("sky_grid_title", "")) + "[/b]\n"
		elif t.has("horizon_log"):
			body_text += "[b]Horizon Log:[/b]\n" + str(t.get("horizon_log", "")) + "\n\n[b]Nakshatra Clue:[/b]\n" + str(t.get("nakshatra_clue", ""))
		terrace_log_text.text = body_text
		
	var options: Array = []
	if t.has("compass_options"):
		options = t.get("compass_options", [])
	elif t.has("candidate_patterns"):
		for cand in t.get("candidate_patterns", []):
			if typeof(cand) == TYPE_DICTIONARY:
				options.append(str(cand.get("label", "")))
			else:
				options.append(str(cand))
	elif t.has("star_nodes"):
		for sn in t.get("star_nodes", []):
			if typeof(sn) == TYPE_DICTIONARY:
				options.append(str(sn.get("label", "")))
			else:
				options.append(str(sn))
	elif t.has("options"):
		options = t.get("options", [])
		
	for i in range(l2_choice_buttons.size()):
		var btn: Button = l2_choice_buttons[i]
		if not btn:
			continue
		if i < options.size():
			btn.text = str(options[i])
			btn.visible = true
			btn.disabled = false
		else:
			btn.visible = false

func _on_astro_l2_choice_selected(index: int) -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(1)
	var tasks: Array = lvl_data.get("challenges", lvl_data.get("scenarios", []))
	var t: Dictionary = tasks[astro_l2_sub_idx]
	var is_correct: bool = (index == int(t.get("correct", 0)))
	
	current_astro_task_passed = is_correct
	var fb: String = "Accurate sky reading deduced!" if is_correct else "Incorrect deduction from the observation log."
	var explanation_str: String = str(t.get("explanation", ""))
	
	_show_astro_feedback(is_correct, fb, explanation_str)

# Astro Level 3
func _setup_astro_level_3() -> void:
	if l1_container:
		l1_container.visible = false
	if l2_container:
		l2_container.visible = false
	if l3_container:
		l3_container.visible = true
		
	if astro_progress_label:
		astro_progress_label.text = "Final Synthesis: Field Notebook"
		
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(2)
	var nb: Dictionary = lvl_data.get("scenario", lvl_data.get("notebook", {}))
	
	if notebook_context_text:
		var txt: String = "[b][u]" + str(nb.get("title", "OBSERVER'S FIELD NOTEBOOK")) + "[/u][/b]\n\n" + str(nb.get("context", ""))
		notebook_context_text.text = txt
		
	var fields: Array = nb.get("fields", [])
	for i in range(field_buttons.size()):
		var ob: OptionButton = field_buttons[i]
		if not ob:
			continue
		ob.clear()
		if i < fields.size():
			var field_data: Dictionary = fields[i]
			var opts: Array = field_data.get("options", [])
			for opt in opts:
				ob.add_item(str(opt))
			ob.visible = true
			ob.selected = 0
		else:
			ob.visible = false

func _on_astro_l3_submit_pressed() -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(2)
	var nb: Dictionary = lvl_data.get("scenario", lvl_data.get("notebook", {}))
	var fields: Array = nb.get("fields", [])
	
	var is_all_correct: bool = true
	var error_field_title: String = ""
	
	for i in range(fields.size()):
		var field_data: Dictionary = fields[i]
		var correct_idx: int = int(field_data.get("correct", 0))
		var ob: OptionButton = field_buttons[i]
		if ob.selected != correct_idx:
			is_all_correct = false
			error_field_title = str(field_data.get("title", "Field " + str(i + 1)))
			break
			
	if is_all_correct:
		current_astro_task_passed = true
		var syn: Dictionary = nb.get("synthesis", {})
		_show_astro_feedback(true, "Master Celestial Synthesis Verified!", str(syn.get("summary", "Your synthesis perfectly links lunar phase, nakshatra position, solar motion, and planetary transit.")))
	else:
		current_astro_task_passed = false
		_show_astro_feedback(false, "Deduction Discrepancy Found", "Review your deduction for [" + error_field_title + "]. Re-check the terrace shadow log and celestial alignments.")

func _show_astro_feedback(is_correct: bool, feedback_text_content: String, explanation: String) -> void:
	if astro_level_content:
		astro_level_content.visible = false
	if astro_feedback_view:
		astro_feedback_view.visible = true
		
	if is_correct:
		if astro_status_label:
			astro_status_label.text = "★ CELESTIAL OBSERVATION VERIFIED ★"
			astro_status_label.modulate = Color(0.4, 1.0, 0.4, 1.0)
		if astro_feedback_msg:
			astro_feedback_msg.text = "[center][b][color=#55ff55]" + feedback_text_content + "[/color][/b][/center]"
		if astro_explanation_box:
			if explanation_box:
				explanation_box.text = "[b]Scholarly Jyotisha Commentary:[/b]\n" + explanation
			astro_explanation_box.text = "[b]Scholarly Jyotisha Commentary:[/b]\n" + explanation
		if btn_astro_feedback_action:
			btn_astro_feedback_action.text = "Proceed ➔"
			btn_astro_feedback_action.modulate = Color(1.0, 0.92, 0.7, 1.0)
	else:
		if astro_status_label:
			astro_status_label.text = "OBSERVATIONAL DISCREPANCY"
			astro_status_label.modulate = Color(1.0, 0.35, 0.35, 1.0)
		if astro_feedback_msg:
			astro_feedback_msg.text = "[center][b][color=#ff6666]" + feedback_text_content + "[/color][/b][/center]"
		if astro_explanation_box:
			astro_explanation_box.text = "[b]Astronomical Insight:[/b]\n" + explanation + "\n\n[i]Examine the horizon coordinates and nakshatras carefully.[/i]"
		if btn_astro_feedback_action:
			btn_astro_feedback_action.text = "🔄 Try Again"
			btn_astro_feedback_action.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_astro_feedback_action_pressed() -> void:
	if current_astro_task_passed:
		if current_astro_level_idx == 0:
			if l1_sequencer_box and l1_sequencer_box.visible:
				if astro_feedback_view:
					astro_feedback_view.visible = false
				if astro_level_content:
					astro_level_content.visible = true
				_load_astro_l1_mini_obs(0)
			elif l1_mini_obs_box and l1_mini_obs_box.visible:
				var total_mini: int = AstronomyMasteryData.get_level(0).get("mini_observations", []).size()
				if astro_l1_mini_obs_idx + 1 < total_mini:
					if astro_feedback_view:
						astro_feedback_view.visible = false
					if astro_level_content:
						astro_level_content.visible = true
					_load_astro_l1_mini_obs(astro_l1_mini_obs_idx + 1)
				else:
					_complete_astro_level(0)
		elif current_astro_level_idx == 1:
			var total_challenges: int = AstronomyMasteryData.get_level(1).get("challenges", AstronomyMasteryData.get_level(1).get("scenarios", [])).size()
			if astro_l2_sub_idx + 1 < total_challenges:
				if astro_feedback_view:
					astro_feedback_view.visible = false
				if astro_level_content:
					astro_level_content.visible = true
				_load_astro_level_2_task(astro_l2_sub_idx + 1)
			else:
				_complete_astro_level(1)
		elif current_astro_level_idx == 2:
			_complete_astro_level(2)
	else:
		if astro_feedback_view:
			astro_feedback_view.visible = false
		if astro_level_content:
			astro_level_content.visible = true

func _complete_astro_level(level_idx: int) -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(level_idx)
	var lvl_id: String = str(lvl_data.get("id", ""))
	if GameState:
		GameState.complete_astro_mastery_stage(lvl_id)
		
	_update_astro_nav_bar()
	
	if level_idx < 2:
		_show_astro_level_complete_screen(level_idx)
	else:
		_show_astro_final_completion_screen()

func _show_astro_level_complete_screen(level_idx: int) -> void:
	if astro_level_content:
		astro_level_content.visible = false
	if astro_feedback_view:
		astro_feedback_view.visible = false
	if astro_level_complete_view:
		astro_level_complete_view.visible = true
		
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(level_idx)
	var next_lvl_data: Dictionary = AstronomyMasteryData.get_level(level_idx + 1)
	
	if astro_lvl_comp_badge:
		astro_lvl_comp_badge.text = "★ LEVEL " + str(level_idx + 1) + " COMPLETE ★"
	if astro_lvl_comp_title:
		astro_lvl_comp_title.text = str(lvl_data.get("title", "")).to_upper() + " MASTERED"
	if astro_lvl_comp_quote:
		astro_lvl_comp_quote.text = "[center][color=#ffdd88]\"" + str(lvl_data.get("complete_quote", "")) + "\"[/color][/center]"
	if btn_astro_proceed_level:
		btn_astro_proceed_level.text = "Unlock & Begin Level " + str(level_idx + 2) + ": " + str(next_lvl_data.get("title", "")) + " ➔"

func _on_astro_proceed_level_pressed() -> void:
	if current_astro_level_idx < 2:
		_load_astro_level(current_astro_level_idx + 1)

func _on_astro_nav_pressed(index: int) -> void:
	var lvl_data: Dictionary = AstronomyMasteryData.get_level(index)
	var l_id: String = str(lvl_data.get("id", ""))
	if GameState and GameState.is_astro_mastery_stage_unlocked(l_id):
		_load_astro_level(index)

func _show_astro_final_completion_screen() -> void:
	if astro_level_content:
		astro_level_content.visible = false
	if astro_feedback_view:
		astro_feedback_view.visible = false
	if astro_level_complete_view:
		astro_level_complete_view.visible = false
	if astro_completion_view:
		astro_completion_view.visible = true
		
	if astro_comp_badge:
		astro_comp_badge.text = "🏆 ASTRONOMY MASTERY COMPLETE 🏆"
	if astro_comp_title:
		astro_comp_title.text = "SCHOLAR OF JYOTISHA — LIVING HERITAGE OF NALANDA"
	if astro_comp_quote:
		astro_comp_quote.text = "[center][color=#ffdd88]\"You did not simply look at the sky.\n\nYou learned to observe it, compare it, and draw meaning from what you saw.\n\nThat is the beginning of true astronomical understanding.\"[/color][/center]"

func _on_conclude_astro_mastery_pressed() -> void:
	if GameState:
		GameState.complete_astro_mastery()
	mastery_completed.emit()
	var cb: Callable = _on_complete_callback
	close_ui()
	if cb.is_valid():
		cb.call()
	else:
		_trigger_fallback_completion_flow()

# ==============================================================================
# MEDICINE MASTERY IMPLEMENTATION
# ==============================================================================
func _setup_medicine_mastery(forced_level_idx: int = -1) -> void:
	if title_label:
		title_label.text = "MEDICINE MASTERY"
	if subtitle_label:
		subtitle_label.text = "THE HEALER'S PATH — FINAL MASTERY OF AYURVEDA & CIKITSA"
		
	if forced_level_idx >= 0 and forced_level_idx < MedicineMasteryData.get_level_count():
		current_med_level_idx = forced_level_idx
	else:
		current_med_level_idx = 0
		for i in range(MedicineMasteryData.get_level_count()):
			var lvl_data: Dictionary = MedicineMasteryData.get_level(i)
			var lvl_id: String = str(lvl_data.get("id", ""))
			if GameState and not GameState.is_med_mastery_stage_complete(lvl_id):
				current_med_level_idx = i
				break
				
	_load_med_level(current_med_level_idx)

func _update_med_nav_bar() -> void:
	for i in range(med_nav_buttons.size()):
		var btn: Button = med_nav_buttons[i]
		if not btn:
			continue
			
		var lvl_data: Dictionary = MedicineMasteryData.get_level(i)
		var l_id: String = str(lvl_data.get("id", ""))
		var nav_label: String = str(lvl_data.get("nav_label", "[ " + str(i + 1) + " ] LEVEL"))
		
		var is_complete: bool = GameState.is_med_mastery_stage_complete(l_id) if GameState else false
		var is_unlocked: bool = GameState.is_med_mastery_stage_unlocked(l_id) if GameState else (i == 0)
		var is_current: bool = (i == current_med_level_idx)
		
		if is_complete:
			btn.text = "✓ " + nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(0.5, 1.0, 0.4, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else (style_nav_done if style_nav_done else style_nav_normal))
		elif is_unlocked:
			btn.text = nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else style_nav_normal)
		else:
			btn.text = "🔒 " + nav_label
			btn.disabled = true
			btn.add_theme_color_override("font_color", Color(0.55, 0.5, 0.45, 0.7))
			btn.add_theme_stylebox_override("normal", style_nav_normal)

func _load_med_level(level_idx: int) -> void:
	current_med_level_idx = level_idx
	current_med_task_passed = false
	
	_update_med_nav_bar()
	
	if med_feedback_view:
		med_feedback_view.visible = false
	if med_level_complete_view:
		med_level_complete_view.visible = false
	if med_completion_view:
		med_completion_view.visible = false
	if med_level_content:
		med_level_content.visible = true
		
	var lvl_data: Dictionary = MedicineMasteryData.get_level(level_idx)
	if lvl_data.is_empty():
		return
		
	if med_title_label:
		med_title_label.text = ("LEVEL " + str(level_idx + 1) + ": " + str(lvl_data.get("title", ""))).to_upper()
	if med_instructions_label:
		med_instructions_label.text = str(lvl_data.get("instructions", ""))
		
	if level_idx == 0:
		_setup_med_level_1()
	elif level_idx == 1:
		_setup_med_level_2()
	elif level_idx == 2:
		_setup_med_level_3()

# Med Level 1
func _setup_med_level_1() -> void:
	if med_l1_container:
		med_l1_container.visible = true
	if med_l2_container:
		med_l2_container.visible = false
	if med_l3_container:
		med_l3_container.visible = false
		
	med_l1_sub_idx = 0
	_load_med_level_1_case(0)

func _load_med_level_1_case(case_idx: int) -> void:
	med_l1_sub_idx = case_idx
	med_l1_selected_symptoms.clear()
	
	var lvl_data: Dictionary = MedicineMasteryData.get_level(0)
	var cases: Array = lvl_data.get("cases", [])
	if case_idx < 0 or case_idx >= cases.size():
		return
		
	if med_progress_label:
		med_progress_label.text = "Patient Case " + str(case_idx + 1) + " of " + str(cases.size())
		
	var c: Dictionary = cases[case_idx]
	if patient_title:
		patient_title.text = "PATIENT OBSERVATION CARD — " + str(c.get("title", "")).to_upper()
	if patient_desc_text:
		patient_desc_text.text = "[b]Clinical Presentation:[/b]\n" + str(c.get("patient_desc", "")) + "\n\n[b]Visible Signs:[/b]\n" + str(c.get("visible_signs", ""))
		
	var symptoms: Array = c.get("symptom_pool", [])
	for i in range(symptom_buttons.size()):
		var btn: Button = symptom_buttons[i]
		if i < symptoms.size():
			btn.text = str(symptoms[i].get("name", ""))
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1, 1, 1, 1)
		else:
			btn.visible = false
			
	_update_med_l1_notes_display()

func _on_med_l1_symptom_toggled(index: int) -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(0)
	var cases: Array = lvl_data.get("cases", [])
	var c: Dictionary = cases[med_l1_sub_idx]
	var symptoms: Array = c.get("symptom_pool", [])
	if index < 0 or index >= symptoms.size():
		return
		
	var sym_id: String = str(symptoms[index].get("id", ""))
	if med_l1_selected_symptoms.has(sym_id):
		med_l1_selected_symptoms.erase(sym_id)
		symptom_buttons[index].modulate = Color(1, 1, 1, 1)
	else:
		med_l1_selected_symptoms.append(sym_id)
		symptom_buttons[index].modulate = Color(0.5, 1.0, 0.5, 1.0)
		
	_update_med_l1_notes_display()

func _update_med_l1_notes_display() -> void:
	if not healers_notes_label:
		return
	if med_l1_selected_symptoms.is_empty():
		healers_notes_label.text = "HEALER'S NOTES: [ None Selected — Click matching symptoms below ]"
	else:
		var lvl_data: Dictionary = MedicineMasteryData.get_level(0)
		var c: Dictionary = lvl_data.get("cases", [])[med_l1_sub_idx]
		var symptoms: Array = c.get("symptom_pool", [])
		var names: Array[String] = []
		for s in symptoms:
			if med_l1_selected_symptoms.has(str(s.get("id", ""))):
				names.append(str(s.get("name", "")))
		healers_notes_label.text = "HEALER'S NOTES: [ " + ", ".join(names) + " ]"

func _on_med_l1_confirm_pressed() -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(0)
	var cases: Array = lvl_data.get("cases", [])
	var c: Dictionary = cases[med_l1_sub_idx]
	var correct_ids: Array = c.get("required_symptoms", [])
	
	if med_l1_selected_symptoms.is_empty():
		_show_med_feedback(false, "No Symptoms Recorded", "As a vaidya, you must record the primary clinical manifestations before confirming.")
		return
		
	var is_match: bool = true
	if med_l1_selected_symptoms.size() != correct_ids.size():
		is_match = false
	else:
		for id in correct_ids:
			if not med_l1_selected_symptoms.has(str(id)):
				is_match = false
				break
				
	current_med_task_passed = is_match
	var fb: String = "Accurate clinical observation." if is_match else "Some selected signs do not match the primary pathology."
	var explanation_str: String = str(c.get("explanation", ""))
	
	_show_med_feedback(is_match, fb, explanation_str)

# Med Level 2
func _setup_med_level_2() -> void:
	if med_l1_container:
		med_l1_container.visible = false
	if med_l2_container:
		med_l2_container.visible = true
	if med_l3_container:
		med_l3_container.visible = false
		
	med_l2_sub_idx = 0
	_load_med_level_2_formulation(0)

func _load_med_level_2_formulation(form_idx: int) -> void:
	med_l2_sub_idx = form_idx
	med_l2_selected_herbs.clear()
	med_l2_selected_method = ""
	
	var lvl_data: Dictionary = MedicineMasteryData.get_level(1)
	var cases: Array = lvl_data.get("cases", [])
	if form_idx < 0 or form_idx >= cases.size():
		return
		
	if med_progress_label:
		med_progress_label.text = "Formulation " + str(form_idx + 1) + " of " + str(cases.size())
		
	var f: Dictionary = cases[form_idx]
	if apothecary_title:
		apothecary_title.text = "APOTHECARY BENCH — " + str(f.get("title", "")).to_upper()
	if apothecary_goal_text:
		apothecary_goal_text.text = "[b]Clinical Target:[/b]\n" + str(f.get("clinical_target", "")) + "\n\n[b]Pathology Insight:[/b]\n" + str(f.get("pathology_insight", ""))
		
	var herbs: Array = f.get("available_herbs", [])
	for i in range(herb_buttons.size()):
		var btn: Button = herb_buttons[i]
		if i < herbs.size():
			btn.text = str(herbs[i].get("name", ""))
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1, 1, 1, 1)
		else:
			btn.visible = false
			
	var methods: Array = f.get("preparation_methods", [])
	for i in range(method_buttons.size()):
		var btn: Button = method_buttons[i]
		if i < methods.size():
			btn.text = str(methods[i].get("label", ""))
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1, 1, 1, 1)
		else:
			btn.visible = false
			
	_update_med_l2_mortar_display()

func _on_med_l2_herb_toggled(index: int) -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(1)
	var cases: Array = lvl_data.get("cases", [])
	var f: Dictionary = cases[med_l2_sub_idx]
	var herbs: Array = f.get("available_herbs", [])
	if index < 0 or index >= herbs.size():
		return
		
	var h_id: String = str(herbs[index].get("id", ""))
	if med_l2_selected_herbs.has(h_id):
		med_l2_selected_herbs.erase(h_id)
		herb_buttons[index].modulate = Color(1, 1, 1, 1)
	else:
		if med_l2_selected_herbs.size() < 3:
			med_l2_selected_herbs.append(h_id)
			herb_buttons[index].modulate = Color(0.4, 1.0, 0.4, 1.0)
			
	_update_med_l2_mortar_display()

func _on_med_l2_method_selected(index: int) -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(1)
	var cases: Array = lvl_data.get("cases", [])
	var f: Dictionary = cases[med_l2_sub_idx]
	var methods: Array = f.get("preparation_methods", [])
	if index < 0 or index >= methods.size():
		return
		
	med_l2_selected_method = str(methods[index].get("id", ""))
	for i in range(method_buttons.size()):
		if i == index:
			method_buttons[i].modulate = Color(1.0, 0.9, 0.4, 1.0)
		else:
			method_buttons[i].modulate = Color(1, 1, 1, 1)
			
	_update_med_l2_mortar_display()

func _update_med_l2_mortar_display() -> void:
	if not mortar_bowl_label:
		return
		
	var lvl_data: Dictionary = MedicineMasteryData.get_level(1)
	var cases: Array = lvl_data.get("cases", [])
	var f: Dictionary = cases[med_l2_sub_idx]
	var herbs: Array = f.get("available_herbs", [])
	var methods: Array = f.get("preparation_methods", [])
	
	var herb_names: Array[String] = []
	for h in herbs:
		if med_l2_selected_herbs.has(str(h.get("id", ""))):
			herb_names.append(str(h.get("name", "")))
			
	var herb_str: String = "[ Empty Bowl ]" if herb_names.is_empty() else "[ " + ", ".join(herb_names) + " ]"
	var method_str: String = "[ Method: None ]"
	for m in methods:
		if str(m.get("id", "")) == med_l2_selected_method:
			method_str = "[ " + str(m.get("label", "")) + " ]"
			break
			
	mortar_bowl_label.text = "🥣 PREPARATION BOWL: " + herb_str + " | " + method_str

func _on_med_l2_prepare_pressed() -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(1)
	var cases: Array = lvl_data.get("cases", [])
	var f: Dictionary = cases[med_l2_sub_idx]
	var correct_herbs: Array = f.get("required_herbs", [])
	var methods: Array = f.get("preparation_methods", [])
	
	var correct_method: String = ""
	for m in methods:
		if bool(m.get("is_correct", false)):
			correct_method = str(m.get("id", ""))
			break
	
	if med_l2_selected_herbs.size() < 3:
		_show_med_feedback(false, "Incomplete Herb Compound", "A synergistic formulation requires exactly 3 active herbs from the shelf.")
		return
		
	if med_l2_selected_method == "":
		_show_med_feedback(false, "No Preparation Method Chosen", "Select the classical preparation technique (e.g. Kwatha, Churna, Taila) for compounding.")
		return
		
	var herbs_match: bool = true
	for h_id in correct_herbs:
		if not med_l2_selected_herbs.has(str(h_id)):
			herbs_match = false
			break
			
	var method_match: bool = (med_l2_selected_method == correct_method)
	var is_correct: bool = herbs_match and method_match
	
	current_med_task_passed = is_correct
	var fb: String = "Harmonious medicinal formulation prepared." if is_correct else "Formulation imbalance detected."
	var explanation_str: String = str(f.get("explanation", ""))
	
	_show_med_feedback(is_correct, fb, explanation_str)

# Med Level 3
func _setup_med_level_3() -> void:
	if med_l1_container:
		med_l1_container.visible = false
	if med_l2_container:
		med_l2_container.visible = false
	if med_l3_container:
		med_l3_container.visible = true
		
	if med_progress_label:
		med_progress_label.text = "Final Synthesis: Royal Patient Case"
		
	var lvl_data: Dictionary = MedicineMasteryData.get_level(2)
	var scenario: Dictionary = lvl_data.get("scenario", {})
	
	if clinical_dossier_text:
		var txt: String = "[b][u]" + str(scenario.get("title", "CLINICAL DOSSIER")) + "[/u][/b]\n\n" + str(scenario.get("context", ""))
		clinical_dossier_text.text = txt
		
	var fields: Array = scenario.get("fields", [])
	for i in range(med_field_buttons.size()):
		var ob: OptionButton = med_field_buttons[i]
		if not ob:
			continue
		ob.clear()
		if i < fields.size():
			var field_data: Dictionary = fields[i]
			var opts: Array = field_data.get("options", [])
			for opt in opts:
				ob.add_item(str(opt))
			ob.visible = true
			ob.selected = 0
		else:
			ob.visible = false

func _on_med_l3_submit_pressed() -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(2)
	var scenario: Dictionary = lvl_data.get("scenario", {})
	var fields: Array = scenario.get("fields", [])
	
	var is_all_correct: bool = true
	var error_field_title: String = ""
	
	for i in range(fields.size()):
		var field_data: Dictionary = fields[i]
		var correct_idx: int = int(field_data.get("correct", 0))
		var ob: OptionButton = med_field_buttons[i]
		if ob.selected != correct_idx:
			is_all_correct = false
			error_field_title = str(field_data.get("title", "Field " + str(i + 1)))
			break
			
	if is_all_correct:
		current_med_task_passed = true
		var syn: Dictionary = scenario.get("synthesis", {})
		_show_med_feedback(true, "Master Treatment Protocol Verified!", str(syn.get("summary", "Your comprehensive protocol integrates authentic doshic diagnosis, classical rasayana formulation, proper vehicle, and lifestyle regimen.")))
	else:
		current_med_task_passed = false
		_show_med_feedback(false, "Protocol Flaw Detected", "Review your deduction for [" + error_field_title + "]. Ensure the herbs and vehicle synergistically balance Vata-Kapha without aggravating Pitta.")

func _show_med_feedback(is_correct: bool, feedback_text_content: String, explanation: String) -> void:
	if med_level_content:
		med_level_content.visible = false
	if med_feedback_view:
		med_feedback_view.visible = true
		
	if is_correct:
		if med_status_label:
			med_status_label.text = "★ CLINICAL OBSERVATION VERIFIED ★"
			med_status_label.modulate = Color(0.4, 1.0, 0.4, 1.0)
		if med_feedback_msg:
			med_feedback_msg.text = "[center][b][color=#55ff55]" + feedback_text_content + "[/color][/b][/center]"
		if med_explanation_box:
			med_explanation_box.text = "[b]Scholarly Vaidya Commentary:[/b]\n" + explanation
		if btn_med_feedback_action:
			btn_med_feedback_action.text = "Proceed ➔"
			btn_med_feedback_action.modulate = Color(1.0, 0.92, 0.7, 1.0)
	else:
		if med_status_label:
			med_status_label.text = "DIAGNOSTIC / COMPOUNDING ERROR"
			med_status_label.modulate = Color(1.0, 0.35, 0.35, 1.0)
		if med_feedback_msg:
			med_feedback_msg.text = "[center][b][color=#ff6666]" + feedback_text_content + "[/color][/b][/center]"
		if med_explanation_box:
			med_explanation_box.text = "[b]Ayurvedic Clinical Insight:[/b]\n" + explanation + "\n\n[i]Examine the gunas, virya, and doshic equilibrium.[/i]"
		if btn_med_feedback_action:
			btn_med_feedback_action.text = "🔄 Try Again"
			btn_med_feedback_action.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_med_feedback_action_pressed() -> void:
	if current_med_task_passed:
		if current_med_level_idx == 0:
			var total_cases: int = MedicineMasteryData.get_level(0).get("cases", []).size()
			if med_l1_sub_idx + 1 < total_cases:
				if med_feedback_view:
					med_feedback_view.visible = false
				if med_level_content:
					med_level_content.visible = true
				_load_med_level_1_case(med_l1_sub_idx + 1)
			else:
				_complete_med_level(0)
		elif current_med_level_idx == 1:
			var total_forms: int = MedicineMasteryData.get_level(1).get("cases", []).size()
			if med_l2_sub_idx + 1 < total_forms:
				if med_feedback_view:
					med_feedback_view.visible = false
				if med_level_content:
					med_level_content.visible = true
				_load_med_level_2_formulation(med_l2_sub_idx + 1)
			else:
				_complete_med_level(1)
		elif current_med_level_idx == 2:
			_complete_med_level(2)
	else:
		if med_feedback_view:
			med_feedback_view.visible = false
		if med_level_content:
			med_level_content.visible = true

func _complete_med_level(level_idx: int) -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(level_idx)
	var lvl_id: String = str(lvl_data.get("id", ""))
	if GameState:
		GameState.complete_med_mastery_stage(lvl_id)
		
	_update_med_nav_bar()
	
	if level_idx < 2:
		_show_med_level_complete_screen(level_idx)
	else:
		_show_med_final_completion_screen()

func _show_med_level_complete_screen(level_idx: int) -> void:
	if med_level_content:
		med_level_content.visible = false
	if med_feedback_view:
		med_feedback_view.visible = false
	if med_level_complete_view:
		med_level_complete_view.visible = true
		
	var lvl_data: Dictionary = MedicineMasteryData.get_level(level_idx)
	var next_lvl_data: Dictionary = MedicineMasteryData.get_level(level_idx + 1)
	
	if med_lvl_comp_badge:
		med_lvl_comp_badge.text = "★ LEVEL " + str(level_idx + 1) + " COMPLETE ★"
	if med_lvl_comp_title:
		med_lvl_comp_title.text = str(lvl_data.get("title", "")).to_upper() + " MASTERED"
	if med_lvl_comp_quote:
		med_lvl_comp_quote.text = "[center][color=#ffdd88]\"" + str(lvl_data.get("completion_quote", lvl_data.get("complete_quote", ""))) + "\"[/color][/center]"
	if btn_med_proceed_level:
		btn_med_proceed_level.text = "Unlock & Begin Level " + str(level_idx + 2) + ": " + str(next_lvl_data.get("title", "")) + " ➔"

func _on_med_proceed_level_pressed() -> void:
	if current_med_level_idx < 2:
		_load_med_level(current_med_level_idx + 1)

func _on_med_nav_pressed(index: int) -> void:
	var lvl_data: Dictionary = MedicineMasteryData.get_level(index)
	var l_id: String = str(lvl_data.get("id", ""))
	if GameState and GameState.is_med_mastery_stage_unlocked(l_id):
		_load_med_level(index)

func _show_med_final_completion_screen() -> void:
	if med_level_content:
		med_level_content.visible = false
	if med_feedback_view:
		med_feedback_view.visible = false
	if med_level_complete_view:
		med_level_complete_view.visible = false
	if med_completion_view:
		med_completion_view.visible = true
		
	if med_comp_badge:
		med_comp_badge.text = "🏆 MEDICINE MASTERY COMPLETE 🏆"
	if med_comp_title:
		med_comp_title.text = "SCHOLAR OF AYURVEDA — LIVING HERITAGE OF NALANDA"
	if med_comp_quote:
		med_comp_quote.text = "[center][color=#ffdd88]\"You did not simply remember remedies.\n\nYou observed carefully, connected what you saw with what you had learned, and chose your response with purpose.\n\nThat is the beginning of a true healer's understanding.\"[/color][/center]"

func _on_conclude_med_mastery_pressed() -> void:
	if GameState:
		GameState.complete_med_mastery()
	mastery_completed.emit()
	var cb: Callable = _on_complete_callback
	close_ui()
	if cb.is_valid():
		cb.call()
	else:
		_trigger_fallback_completion_flow()

# ==============================================================================
# PHILOSOPHY MASTERY IMPLEMENTATION (3 ARGUMENT & DEBATE LEVELS)
# ==============================================================================
func _setup_philosophy_mastery(forced_level_idx: int = -1) -> void:
	if title_label:
		title_label.text = "PHILOSOPHY MASTERY"
	if subtitle_label:
		subtitle_label.text = "THE SCHOLAR'S DEBATE — FINAL MASTERY OF DARSANA & NYAYA"
		
	if forced_level_idx >= 0 and forced_level_idx < PhilosophyMasteryData.get_level_count():
		current_phil_level_idx = forced_level_idx
	else:
		current_phil_level_idx = 0
		for i in range(PhilosophyMasteryData.get_level_count()):
			var lvl_data: Dictionary = PhilosophyMasteryData.get_level(i)
			var lvl_id: String = str(lvl_data.get("id", ""))
			if GameState and not GameState.is_phil_mastery_stage_complete(lvl_id):
				current_phil_level_idx = i
				break
				
	_load_phil_level(current_phil_level_idx)

func _update_phil_nav_bar() -> void:
	for i in range(phil_nav_buttons.size()):
		var btn: Button = phil_nav_buttons[i]
		if not btn:
			continue
			
		var lvl_data: Dictionary = PhilosophyMasteryData.get_level(i)
		var l_id: String = str(lvl_data.get("id", ""))
		var nav_label: String = str(lvl_data.get("nav_label", "[ " + str(i + 1) + " ] LEVEL"))
		
		var is_complete: bool = GameState.is_phil_mastery_stage_complete(l_id) if GameState else false
		var is_unlocked: bool = GameState.is_phil_mastery_stage_unlocked(l_id) if GameState else (i == 0)
		var is_current: bool = (i == current_phil_level_idx)
		
		if is_complete:
			btn.text = "✓ " + nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(0.5, 1.0, 0.4, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else (style_nav_done if style_nav_done else style_nav_normal))
		elif is_unlocked:
			btn.text = nav_label
			btn.disabled = false
			btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6, 1.0))
			btn.add_theme_stylebox_override("normal", style_nav_active if is_current else style_nav_normal)
		else:
			btn.text = "🔒 " + nav_label
			btn.disabled = true
			btn.add_theme_color_override("font_color", Color(0.55, 0.5, 0.45, 0.7))
			btn.add_theme_stylebox_override("normal", style_nav_normal)

func _load_phil_level(level_idx: int) -> void:
	current_phil_level_idx = level_idx
	current_phil_task_passed = false
	
	_update_phil_nav_bar()
	
	if phil_feedback_view:
		phil_feedback_view.visible = false
	if phil_level_complete_view:
		phil_level_complete_view.visible = false
	if phil_completion_view:
		phil_completion_view.visible = false
	if phil_level_content:
		phil_level_content.visible = true
		
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(level_idx)
	if lvl_data.is_empty():
		return
		
	if phil_title_label:
		phil_title_label.text = ("LEVEL " + str(level_idx + 1) + ": " + str(lvl_data.get("title", ""))).to_upper()
	if phil_instructions_label:
		phil_instructions_label.text = str(lvl_data.get("instructions", ""))
		
	if level_idx == 0:
		_setup_phil_level_1()
	elif level_idx == 1:
		_setup_phil_level_2()
	elif level_idx == 2:
		_setup_phil_level_3()

# Phil Level 1: The Scholar's Claim (Argument Board)
func _setup_phil_level_1() -> void:
	if phil_l1_container:
		phil_l1_container.visible = true
	if phil_l2_container:
		phil_l2_container.visible = false
	if phil_l3_container:
		phil_l3_container.visible = false
		
	phil_l1_sub_idx = 0
	_load_phil_level_1_puzzle(0)

func _load_phil_level_1_puzzle(puzzle_idx: int) -> void:
	phil_l1_sub_idx = puzzle_idx
	phil_l1_placed_slots = ["", "", "", ""]
	phil_l1_selected_card_idx = -1
	
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(0)
	var puzzles: Array = lvl_data.get("puzzles", [])
	if puzzle_idx < 0 or puzzle_idx >= puzzles.size():
		return
		
	if phil_progress_label:
		phil_progress_label.text = "Argument Board " + str(puzzle_idx + 1) + " of " + str(puzzles.size())
		
	var p: Dictionary = puzzles[puzzle_idx]
	if phil_l1_context_title:
		phil_l1_context_title.text = "DEBATE PROPOSITION: " + str(p.get("title", "")).to_upper()
	if phil_l1_context_text:
		phil_l1_context_text.text = str(p.get("context", ""))
		
	var cards: Array = p.get("cards", [])
	for i in range(phil_l1_card_buttons.size()):
		var btn: Button = phil_l1_card_buttons[i]
		if i < cards.size():
			btn.text = str(cards[i].get("text", ""))
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1, 1, 1, 1)
		else:
			btn.visible = false
			
	_update_phil_l1_board_display()

func _on_phil_l1_card_clicked(card_idx: int) -> void:
	if phil_l1_selected_card_idx == card_idx:
		phil_l1_selected_card_idx = -1
		phil_l1_card_buttons[card_idx].modulate = Color(1, 1, 1, 1)
	else:
		phil_l1_selected_card_idx = card_idx
		for i in range(phil_l1_card_buttons.size()):
			if i == card_idx:
				phil_l1_card_buttons[i].modulate = Color(1.0, 0.9, 0.3, 1.0)
			else:
				phil_l1_card_buttons[i].modulate = Color(1, 1, 1, 1)

func _on_phil_l1_slot_clicked(slot_idx: int) -> void:
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(0)
	var p: Dictionary = lvl_data.get("puzzles", [])[phil_l1_sub_idx]
	var cards: Array = p.get("cards", [])
	
	if phil_l1_selected_card_idx >= 0 and phil_l1_selected_card_idx < cards.size():
		var card_id: String = str(cards[phil_l1_selected_card_idx].get("id", ""))
		for i in range(phil_l1_placed_slots.size()):
			if phil_l1_placed_slots[i] == card_id:
				phil_l1_placed_slots[i] = ""
				
		phil_l1_placed_slots[slot_idx] = card_id
		phil_l1_selected_card_idx = -1
		for btn in phil_l1_card_buttons:
			btn.modulate = Color(1, 1, 1, 1)
		_update_phil_l1_board_display()
	else:
		if phil_l1_placed_slots[slot_idx] != "":
			phil_l1_placed_slots[slot_idx] = ""
			_update_phil_l1_board_display()

func _update_phil_l1_board_display() -> void:
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(0)
	var p: Dictionary = lvl_data.get("puzzles", [])[phil_l1_sub_idx]
	var cards: Array = p.get("cards", [])
	
	var role_names: Array[String] = ["Claim", "Reason", "Evidence", "Conclusion"]
	
	for s_idx in range(phil_l1_slot_buttons.size()):
		var btn: Button = phil_l1_slot_buttons[s_idx]
		var c_id: String = phil_l1_placed_slots[s_idx]
		if c_id == "":
			btn.text = "[ Click statement below, then click here to assign " + role_names[s_idx] + " ]"
			btn.modulate = Color(0.7, 0.7, 0.7, 0.9)
		else:
			var card_text: String = ""
			for c in cards:
				if str(c.get("id", "")) == c_id:
					card_text = str(c.get("text", ""))
					break
			btn.text = "✓ " + card_text
			btn.modulate = Color(1.0, 0.95, 0.7, 1.0)
			
	# Highlight placed cards in lower tray
	for i in range(phil_l1_card_buttons.size()):
		var btn: Button = phil_l1_card_buttons[i]
		if i < cards.size():
			var c_id: String = str(cards[i].get("id", ""))
			if phil_l1_placed_slots.has(c_id):
				btn.disabled = false
				btn.modulate = Color(0.5, 0.8, 0.5, 0.8)
			else:
				btn.disabled = false
				if i != phil_l1_selected_card_idx:
					btn.modulate = Color(1, 1, 1, 1)

func _on_phil_l1_verify_pressed() -> void:
	for slot_val in phil_l1_placed_slots:
		if slot_val == "":
			_show_phil_feedback(false, "Incomplete Argument Board", "Place statements into all four argument roles (Claim, Reason, Evidence, Conclusion) before verifying.")
			return
			
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(0)
	var p: Dictionary = lvl_data.get("puzzles", [])[phil_l1_sub_idx]
	var targets: Dictionary = p.get("target_roles", {})
	
	var is_correct: bool = (
		phil_l1_placed_slots[0] == str(targets.get("claim", "")) and
		phil_l1_placed_slots[1] == str(targets.get("reason", "")) and
		phil_l1_placed_slots[2] == str(targets.get("evidence", "")) and
		phil_l1_placed_slots[3] == str(targets.get("conclusion", ""))
	)
	
	current_phil_task_passed = is_correct
	var fb: String = "The argument is clearly formed and soundly structured." if is_correct else "The arrangement of argument components contains flawed role placement."
	var explanation_str: String = str(p.get("explanation", ""))
	
	_show_phil_feedback(is_correct, fb, explanation_str)

# Phil Level 2: The Counterargument (Spot Weakness & Builder)
func _setup_phil_level_2() -> void:
	if phil_l1_container:
		phil_l1_container.visible = false
	if phil_l2_container:
		phil_l2_container.visible = true
	if phil_l3_container:
		phil_l3_container.visible = false
		
	phil_l2_sub_idx = 0
	_load_phil_level_2_debate(0)

func _load_phil_level_2_debate(debate_idx: int) -> void:
	phil_l2_sub_idx = debate_idx
	phil_l2_selected_weakness_idx = -1
	phil_l2_selected_response_idx = -1
	
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(1)
	var debates: Array = lvl_data.get("debates", [])
	if debate_idx < 0 or debate_idx >= debates.size():
		return
		
	if phil_progress_label:
		phil_progress_label.text = "Mini-Debate " + str(debate_idx + 1) + " of " + str(debates.size())
		
	var d: Dictionary = debates[debate_idx]
	if phil_l2_debate_title:
		phil_l2_debate_title.text = (str(d.get("scholar_name", "Scholar")) + "'s Proposition — " + str(d.get("title", ""))).to_upper()
	if phil_l2_scholar_speech:
		phil_l2_scholar_speech.text = str(d.get("claim_text", ""))
		
	var weaknesses: Array = d.get("weakness_options", [])
	for i in range(phil_l2_weakness_buttons.size()):
		var btn: Button = phil_l2_weakness_buttons[i]
		if i < weaknesses.size():
			btn.text = str(weaknesses[i].get("text", ""))
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1, 1, 1, 1)
		else:
			btn.visible = false
			
	var responses: Array = d.get("response_options", [])
	for i in range(phil_l2_response_buttons.size()):
		var btn: Button = phil_l2_response_buttons[i]
		if i < responses.size():
			btn.text = str(responses[i].get("text", ""))
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1, 1, 1, 1)
		else:
			btn.visible = false

func _on_phil_l2_weakness_selected(index: int) -> void:
	phil_l2_selected_weakness_idx = index
	for i in range(phil_l2_weakness_buttons.size()):
		if i == index:
			phil_l2_weakness_buttons[i].modulate = Color(1.0, 0.88, 0.35, 1.0)
		else:
			phil_l2_weakness_buttons[i].modulate = Color(1, 1, 1, 1)

func _on_phil_l2_response_selected(index: int) -> void:
	phil_l2_selected_response_idx = index
	for i in range(phil_l2_response_buttons.size()):
		if i == index:
			phil_l2_response_buttons[i].modulate = Color(0.4, 1.0, 0.5, 1.0)
		else:
			phil_l2_response_buttons[i].modulate = Color(1, 1, 1, 1)

func _on_phil_l2_submit_pressed() -> void:
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(1)
	var debates: Array = lvl_data.get("debates", [])
	var d: Dictionary = debates[phil_l2_sub_idx]
	
	if phil_l2_selected_weakness_idx == -1:
		_show_phil_feedback(false, "No Weakness Identified", "Use the Argument Lens to pinpoint the flawed assumption in the scholar's claim before responding.")
		return
		
	if phil_l2_selected_response_idx == -1:
		_show_phil_feedback(false, "No Counterargument Selected", "Select the most sound and balanced counterargument from the response cards.")
		return
		
	var weaknesses: Array = d.get("weakness_options", [])
	var responses: Array = d.get("response_options", [])
	
	var is_weakness_ok: bool = bool(weaknesses[phil_l2_selected_weakness_idx].get("is_correct", false))
	var is_response_ok: bool = bool(responses[phil_l2_selected_response_idx].get("is_correct", false))
	var is_correct: bool = is_weakness_ok and is_response_ok
	
	current_phil_task_passed = is_correct
	var fb: String = "Sound refutation delivered! The assumption was precisely illuminated." if is_correct else "Flaw detected in your dialectical response."
	var explanation_str: String = str(d.get("explanation", ""))
	
	_show_phil_feedback(is_correct, fb, explanation_str)

# Phil Level 3: The Final Debate (Assembly Council)
func _setup_phil_level_3() -> void:
	if phil_l1_container:
		phil_l1_container.visible = false
	if phil_l2_container:
		phil_l2_container.visible = false
	if phil_l3_container:
		phil_l3_container.visible = true
		
	if phil_progress_label:
		phil_progress_label.text = "Final Assembly Debate"
		
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(2)
	var scenario: Dictionary = lvl_data.get("scenario", {})
	
	if phil_l3_council_title:
		phil_l3_council_title.text = (str(scenario.get("opponent_name", "Visiting Acharya")) + " — " + str(scenario.get("title", ""))).to_upper()
	if phil_l3_opponent_speech:
		phil_l3_opponent_speech.text = str(scenario.get("opponent_speech", ""))
		
	var fields: Array = scenario.get("fields", [])
	for i in range(phil_l3_field_buttons.size()):
		var ob: OptionButton = phil_l3_field_buttons[i]
		if not ob:
			continue
		ob.clear()
		if i < fields.size():
			var field_data: Dictionary = fields[i]
			var opts: Array = field_data.get("options", [])
			for opt in opts:
				ob.add_item(str(opt))
			ob.visible = true
			ob.selected = 0
		else:
			ob.visible = false

func _on_phil_l3_submit_pressed() -> void:
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(2)
	var scenario: Dictionary = lvl_data.get("scenario", {})
	var fields: Array = scenario.get("fields", [])
	
	var is_all_correct: bool = true
	var error_field_title: String = ""
	
	for i in range(fields.size()):
		var field_data: Dictionary = fields[i]
		var correct_idx: int = int(field_data.get("correct", 0))
		var ob: OptionButton = phil_l3_field_buttons[i]
		if ob.selected != correct_idx:
			is_all_correct = false
			error_field_title = str(field_data.get("title", "Field " + str(i + 1)))
			break
			
	if is_all_correct:
		current_phil_task_passed = true
		var syn: Dictionary = scenario.get("synthesis", {})
		_show_phil_feedback(true, "Master Debate Synthesis Verified!", str(syn.get("summary", "Your argument is sound. You demonstrated that solitary contemplation and respectful debate are complementary wings of wisdom.")))
	else:
		current_phil_task_passed = false
		_show_phil_feedback(false, "Reasoning Flaw in Final Presentation", "Examine the reasoning once more for [" + error_field_title + "]. Ensure your refutation honors the classical principles of Vada.")

func _show_phil_feedback(is_correct: bool, feedback_text_content: String, explanation: String) -> void:
	if phil_level_content:
		phil_level_content.visible = false
	if phil_feedback_view:
		phil_feedback_view.visible = true
		
	if is_correct:
		if phil_status_label:
			phil_status_label.text = "★ DIALECTICAL REASONING VERIFIED ★"
			phil_status_label.modulate = Color(0.4, 1.0, 0.4, 1.0)
		if phil_feedback_msg:
			phil_feedback_msg.text = "[center][b][color=#55ff55]" + feedback_text_content + "[/color][/b][/center]"
		if phil_explanation_box:
			phil_explanation_box.text = "[b]Scholarly Nyaya Commentary:[/b]\n" + explanation
		if btn_phil_feedback_action:
			btn_phil_feedback_action.text = "Proceed ➔"
			btn_phil_feedback_action.modulate = Color(1.0, 0.92, 0.7, 1.0)
	else:
		if phil_status_label:
			phil_status_label.text = "LOGICAL FLAW DETECTED"
			phil_status_label.modulate = Color(1.0, 0.35, 0.35, 1.0)
		if phil_feedback_msg:
			phil_feedback_msg.text = "[center][b][color=#ff6666]" + feedback_text_content + "[/color][/b][/center]"
		if phil_explanation_box:
			phil_explanation_box.text = "[b]Philosophical Insight:[/b]\n" + explanation + "\n\n[i]Examine the premise and the role each statement plays.[/i]"
		if btn_phil_feedback_action:
			btn_phil_feedback_action.text = "🔄 Try Again"
			btn_phil_feedback_action.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_phil_feedback_action_pressed() -> void:
	if current_phil_task_passed:
		if current_phil_level_idx == 0:
			var total_puzzles: int = PhilosophyMasteryData.get_level(0).get("puzzles", []).size()
			if phil_l1_sub_idx + 1 < total_puzzles:
				if phil_feedback_view:
					phil_feedback_view.visible = false
				if phil_level_content:
					phil_level_content.visible = true
				_load_phil_level_1_puzzle(phil_l1_sub_idx + 1)
			else:
				_complete_phil_level(0)
		elif current_phil_level_idx == 1:
			var total_debates: int = PhilosophyMasteryData.get_level(1).get("debates", []).size()
			if phil_l2_sub_idx + 1 < total_debates:
				if phil_feedback_view:
					phil_feedback_view.visible = false
				if phil_level_content:
					phil_level_content.visible = true
				_load_phil_level_2_debate(phil_l2_sub_idx + 1)
			else:
				_complete_phil_level(1)
		elif current_phil_level_idx == 2:
			_complete_phil_level(2)
	else:
		if phil_feedback_view:
			phil_feedback_view.visible = false
		if phil_level_content:
			phil_level_content.visible = true

func _complete_phil_level(level_idx: int) -> void:
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(level_idx)
	var lvl_id: String = str(lvl_data.get("id", ""))
	if GameState:
		GameState.complete_phil_mastery_stage(lvl_id)
		
	_update_phil_nav_bar()
	
	if level_idx < 2:
		_show_phil_level_complete_screen(level_idx)
	else:
		_show_phil_final_completion_screen()

func _show_phil_level_complete_screen(level_idx: int) -> void:
	if phil_level_content:
		phil_level_content.visible = false
	if phil_feedback_view:
		phil_feedback_view.visible = false
	if phil_level_complete_view:
		phil_level_complete_view.visible = true
		
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(level_idx)
	var next_lvl_data: Dictionary = PhilosophyMasteryData.get_level(level_idx + 1)
	
	if phil_lvl_comp_badge:
		phil_lvl_comp_badge.text = "★ LEVEL " + str(level_idx + 1) + " COMPLETE ★"
	if phil_lvl_comp_title:
		phil_lvl_comp_title.text = str(lvl_data.get("title", "")).to_upper() + " MASTERED"
	if phil_lvl_comp_quote:
		phil_lvl_comp_quote.text = "[center][color=#ffdd88]\"" + str(lvl_data.get("completion_quote", lvl_data.get("complete_quote", ""))) + "\"[/color][/center]"
	if btn_phil_proceed_level:
		btn_phil_proceed_level.text = "Unlock & Begin Level " + str(level_idx + 2) + ": " + str(next_lvl_data.get("title", "")) + " ➔"

func _on_phil_proceed_level_pressed() -> void:
	if current_phil_level_idx < 2:
		_load_phil_level(current_phil_level_idx + 1)

func _on_phil_nav_pressed(index: int) -> void:
	var lvl_data: Dictionary = PhilosophyMasteryData.get_level(index)
	var l_id: String = str(lvl_data.get("id", ""))
	if GameState and GameState.is_phil_mastery_stage_unlocked(l_id):
		_load_phil_level(index)

func _show_phil_final_completion_screen() -> void:
	if phil_level_content:
		phil_level_content.visible = false
	if phil_feedback_view:
		phil_feedback_view.visible = false
	if phil_level_complete_view:
		phil_level_complete_view.visible = false
	if phil_completion_view:
		phil_completion_view.visible = true
		
	if phil_comp_badge:
		phil_comp_badge.text = "🏆 PHILOSOPHY MASTERY COMPLETE 🏆"
	if phil_comp_title:
		phil_comp_title.text = "SCHOLAR OF DARSANA & NYAYA — LIVING HERITAGE OF NALANDA"
	if phil_comp_quote:
		phil_comp_quote.text = "[center][color=#ffdd88]\"You did not win the debate by speaking first.\n\nYou observed the claim, examined the reasoning, questioned the weakness, and formed your own conclusion.\n\nThat is the discipline of thought.\"[/color][/center]"

func _on_conclude_phil_mastery_pressed() -> void:
	if GameState:
		GameState.complete_phil_mastery()
	mastery_completed.emit()
	var cb: Callable = _on_complete_callback
	close_ui()
	if cb.is_valid():
		cb.call()
	else:
		_trigger_fallback_completion_flow()

# ==============================================================================
# CLASSIC FALLBACK SCENARIOS (FOR REMAINING / INTEGRATED DOMAINS)
# ==============================================================================
func _setup_classic_scenario() -> void:
	if title_label:
		title_label.text = "FINAL MASTERY TRIAL"
	if subtitle_label:
		subtitle_label.text = "DISCERNMENT & REASONING OF NALANDA"
		
	var raw_domain: String = GameState.selected_domain if GameState else "mathematics"
	current_scenario = NarrativeMasteryData.get_final_mastery_scenario(raw_domain)

	
	if trial_view:
		trial_view.visible = true
	if feedback_view:
		feedback_view.visible = false
		
	if narrative_text:
		narrative_text.text = str(current_scenario.get("narrative", ""))
	if clues_text:
		clues_text.text = "[b]Scholarly Clues & Constraints:[/b]\n" + str(current_scenario.get("clues", ""))
	if prompt_label:
		prompt_label.text = str(current_scenario.get("prompt", "Choose your scholarly response:"))
		
	var choices: Array = current_scenario.get("choices", [])
	for i in range(option_buttons.size()):
		var btn: Button = option_buttons[i]
		if i < choices.size():
			btn.text = str(choices[i].get("text", ""))
			btn.visible = true
			btn.disabled = false
		else:
			btn.visible = false

func _on_classic_option_selected(index: int) -> void:
	var choices: Array = current_scenario.get("choices", [])
	if index < 0 or index >= choices.size():
		return
	var choice: Dictionary = choices[index]
	is_passed = bool(choice.get("is_best", false))
	
	if trial_view:
		trial_view.visible = false
	if feedback_view:
		feedback_view.visible = true
		
	if is_passed:
		if feedback_status:
			feedback_status.text = "★ MASTER SYNTHESIS ACHIEVED ★"
			feedback_status.modulate = Color(1, 0.85, 0.2, 1)
		if feedback_text:
			feedback_text.text = "[b][color=#55ff55]" + str(choice.get("feedback", "Excellent reasoning!")) + "[/color][/b]"
		if explanation_text:
			explanation_text.text = "[b]Scholarly Analysis:[/b]\n" + str(choice.get("explanation", ""))
		if action_button:
			action_button.text = "🏆 Conclude Mastery & Present to Council"
			action_button.modulate = Color(1, 0.9, 0.4, 1)
	else:
		if feedback_status:
			feedback_status.text = "DECISION FLAW DETECTED"
			feedback_status.modulate = Color(1, 0.4, 0.4, 1)
		if feedback_text:
			feedback_text.text = "[b][color=#ff6666]" + str(choice.get("feedback", "The proposed plan had critical flaws.")) + "[/color][/b]"
		if explanation_text:
			explanation_text.text = "[b]Deficiency Insight:[/b]\n" + str(choice.get("explanation", "")) + "\n\n[i]Review the constraints and deduce the balanced solution.[/i]"
		if action_button:
			action_button.text = "🔄 Re-evaluate Dossier & Retry"
			action_button.modulate = Color(1, 1, 1, 1)

func _on_classic_action_button_pressed() -> void:
	if is_passed:
		if GameState:
			GameState.complete_final_mastery()
		mastery_completed.emit()
		var cb: Callable = _on_complete_callback
		close_ui()
		if cb.is_valid():
			cb.call()
		else:
			_trigger_fallback_completion_flow()
	else:
		if trial_view:
			trial_view.visible = true
		if feedback_view:
			feedback_view.visible = false

func _trigger_fallback_completion_flow() -> void:
	var teachers: Array = get_tree().get_nodes_in_group("teacher3")
	if teachers.size() == 0:
		for node in get_tree().root.find_children("", "Teacher3", true, false):
			teachers.append(node)
	if teachers.size() > 0 and is_instance_valid(teachers[0]):
		var t3 = teachers[0]
		if t3.has_method("_start_teacher3_interaction"):
			t3.call_deferred("_start_teacher3_interaction")
	else:
		var comp_uis: Array = get_tree().get_nodes_in_group("nalanda_completion_ui")
		if comp_uis.size() > 0 and is_instance_valid(comp_uis[0]):
			comp_uis[0].open_completion_sequence()

func close_ui() -> void:
	is_open = false
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
	if GameState:
		GameState.unlock_player_movement()
	ui_closed.emit()
