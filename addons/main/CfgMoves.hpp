class CfgMovesBasic {
    class Default;
    class Actions;
};
class CfgMovesMaleSdr: CfgMovesBasic {
    class StandBase;
    // mark as on ladder animation
    class LadderCivilStatic: StandBase {
        GVAR(isLadder) = 1;
    };
};
