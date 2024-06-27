--[[
   Exports template logging messages to be used by Stellar.
]]

return table.freeze {
	cannotAssignProperty = "The class type '%s' has no assignable property '%s'.",
	cannotFindUnresolvedChild = "Cannot find child named '%s' within '%s'. Check that you're hydrating an existing object.",
	cannotYield = "Yielding not allowed during %s. Restructure your code to avoid yielding here.",
	childInfiniteYield = "Potential infinite yield for '%s' in '%s'. Check that you're hydrating an existing object.",
	destroyedTwice = "`expandedCleanup()` was given something it was already cleaning up. Unclear how to proceed.",
	invalidApplyValue = "[Apply] must be given an array of property tables",
	invalidFusionInstallation = "Stellar got invalid Fusion installation; %s.",
	invalidPropertyType = "'%s.%s' expected a %s type, but got a '%s' type.",
	invalidSpecialKey = "'%s' type special keys aren't accepted by `%s`",
	invalidStateObject = "'%s' type state objects aren't accepted by `%s`",
	noFusionInstallation = "Stellar requires a Fusion installation to be present as a sibling in the data model.",
	noRuntimeProvider = "Stellar requires a runtime provider to function. Set one via `Stellar.setProvider()`.",
	propertySetError = "Error setting property: ERROR_MESSAGE",
	unbindedTwice = "Attempted to unbind twice from %s.",
	unknownMessage = "Unknown error: ERROR_MESSAGE",
	unrecognizedApplyKey = "'%s' type property keys aren't accepted by [Apply]",
	unrecognizedBatchKeys = "[BatchKeys] must be given pairs of special keys with corresponding values.",
	unrecognizedPropertyStage = "'%s' isn't a valid stage for a special key to be applied at.",
}
