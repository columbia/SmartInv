1 pragma solidity 0.5.1;
2 
3 contract Token {
4     string public name;
5     string public symbol;
6     uint public decimals;
7     
8     constructor(string memory _name, string memory _symbol, uint _decimals) public {
9         name = _name;
10         symbol = _symbol;
11         decimals = _decimals;
12     }
13 }
14 
15 contract ERC20Deployer {
16     
17     event newContract(address indexed _contract);
18     
19     function deployNewToken() public {
20         Token token = new Token('test123', 'TST', 18);
21         emit newContract(address(token));
22     }
23 }