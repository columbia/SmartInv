1 pragma solidity 0.4.25;
2 
3 contract RevertReason {
4     
5     ErrorReporter public error;
6     
7     constructor(address _error) public {
8         require(_error != address(0x0));
9         error = ErrorReporter(_error);
10     }
11     
12     function shouldRevert(bool yes) public {
13         if (yes) {
14             error.report("Shit it reverted!");
15         }
16     }
17     
18     function shouldRevertWithReturn(bool yes) public returns (uint256) {
19         if (yes) {
20             error.report("Shit it reverted!");
21         }
22         return 42;
23     }
24     
25     function shouldRevertPure(bool yes) public view returns (uint256) {
26         if (yes) {
27             error.report("Shit it reverted!");
28         }
29         return 42;
30     }
31 }
32 
33 
34 contract ErrorReporter {
35     function report(string reason) public pure {
36         revert(reason);
37     }
38 }