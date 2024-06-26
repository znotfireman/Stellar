return table.freeze {
   cannotYield = "Attempted to yield during %s. Consider refactoring your code to avoid yielding here.",
   destroyedTwice = "`expandedCleanup()` was given something it was already cleaning up. Unclear how to proceed.",
   invalidFusionInstallation = "Stellar got invalid Fusion installation; %s.",
   noFusionInstallation = "Stellar requires a Fusion installation to be present as a sibling in the data model.",
   noRuntimeProvider = "Stellar requires a runtime provider to function. Set one via `Stellar.setProvider()`.",
   strictReadError = "'%s' is not a valid member of '%s'.",
   unknownMessage = "Unknown error: ERROR_MESSAGE",
}
