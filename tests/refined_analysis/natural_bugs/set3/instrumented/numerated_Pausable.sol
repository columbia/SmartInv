1 pragma solidity ^0.5.0;
2 
3 import "../GSN/Context.sol";
4 
5 /**
6  * @dev Contract module which allows children to implement an emergency stop
7  * mechanism that can be triggered by an authorized account.
8  *
9  * This module is used through inheritance. It will make available the
10  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
11  * the functions of your contract. Note that they will not be pausable by
12  * simply including this module, only once the modifiers are put in place.
13  */
14 contract Pausable is Context {
15     /**
16      * @dev Emitted when the pause is triggered by a pauser (`account`).
17      */
18     event Paused(address account);
19 
20     /**
21      * @dev Emitted when the pause is lifted by a pauser (`account`).
22      */
23     event Unpaused(address account);
24 
25     bool private _paused;
26 
27     /**
28      * @dev Initializes the contract in unpaused state.
29      */
30     constructor () internal {
31         _paused = false;
32     }
33 
34     /**
35      * @dev Returns true if the contract is paused, and false otherwise.
36      */
37     function paused() public view returns (bool) {
38         return _paused;
39     }
40 
41     /**
42      * @dev Modifier to make a function callable only when the contract is not paused.
43      */
44     modifier whenNotPaused() {
45         require(!_paused, "Pausable: paused");
46         _;
47     }
48 
49     /**
50      * @dev Modifier to make a function callable only when the contract is paused.
51      */
52     modifier whenPaused() {
53         require(_paused, "Pausable: not paused");
54         _;
55     }
56 
57     /**
58      * @dev Called to pause, triggers stopped state.
59      */
60     function _pause() internal whenNotPaused {
61         _paused = true;
62         emit Paused(_msgSender());
63     }
64 
65     /**
66      * @dev Called to unpause, returns to normal state.
67      */
68     function _unpause() internal whenPaused {
69         _paused = false;
70         emit Unpaused(_msgSender());
71     }
72 }
