1 pragma solidity 0.5.5;
2 
3 
4 interface IERC20 {
5 }
6 
7 
8 interface IDeadTokens {
9     function bury(IERC20 token) external;
10     function buried(IERC20 token) external view returns (bool);
11     function callback(IERC20 token, bool valid) external;
12 }
13 
14 
15 interface IOracle {
16     function test(address token) external;
17 }
18 
19 contract DeadTokens is IDeadTokens {
20     mapping (address => TokenState) internal dead;
21     IOracle public oracle;
22     address internal owner;
23     
24     enum TokenState {UNKNOWN, SHIT, FAKE}
25     
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     function bury(IERC20 token) external {
31         oracle.test(address(token));
32     }
33 
34     function buried(IERC20 token) public view returns (bool) {
35         TokenState state = dead[address(token)];
36         
37         if (state == TokenState.SHIT) {
38             return true;
39         }
40         return false;
41     }
42     
43     function setOracle(IOracle _oracle) external {
44         require(msg.sender == owner);
45         oracle = _oracle;
46     }
47         
48     function callback(IERC20 token, bool valid) external {
49         require(msg.sender == address(oracle));
50         TokenState state = valid ? TokenState.SHIT : TokenState.FAKE;
51         dead[address(token)] = state;
52     }
53 }