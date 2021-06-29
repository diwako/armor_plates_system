PREP(initPlates);
PREP(updatePlateUi);
PREP(updateHPUi);
PREP(canAddPlate);
PREP(addPlate);
PREP(canPressKey);
PREP(showDamageFeedbackMarker);
PREP(initAIUnit);
PREP(createProgressBar);
PREP(deleteProgressBar);
PREP(moduleHeal);

if (GVAR(aceMedicalLoaded)) then {
    PREP(handleDamageEhACE);
    PREP(receiveDamageACE);
} else {
    PREP(hitEh);
    PREP(handleDamageEh);
    PREP(handleHealEh);
    PREP(receiveDamage);
    PREP(hasHealItems);
    PREP(addPlayerHoldActions);
    PREP(getHitpointArmor);
    PREP(getItemArmor);
    PREP(startHpRegen);
    PREP(drawDownedUnitIndicator);
    PREP(canRevive);
    PREP(setA3Damage);
    PREP(showDownedSkull);
    PREP(addActionsToUnit);
    PREP(setUnconscious);
    PREP(requestAIRevive);
    PREP(aiMoveAndHealUnit);
};
