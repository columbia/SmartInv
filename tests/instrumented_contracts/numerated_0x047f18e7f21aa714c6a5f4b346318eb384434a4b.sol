1 pragma solidity ^0.5.2;
2 
3 contract ERC20Token {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     function totalSupply() public view returns (uint);
8     function balanceOf(address tokenOwner) public view returns (uint balance);
9     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16  }
17 
18 contract LogERC20 {
19 
20     event hasBeenSent(
21         address sender,
22         address recipient,
23         string target,
24         uint256 amount,
25         address contractAddress
26     );
27 
28     address public erc20ContractAddress;
29     address public bridgeWalletAddress;
30 
31     constructor(address _erc20ContractAddress, address _bridgeWalletAddress ) public {
32        erc20ContractAddress = _erc20ContractAddress;
33        bridgeWalletAddress = _bridgeWalletAddress;
34     }
35 
36     function logSendMemo(
37         uint256 amount,
38         string memory target
39     ) public {
40         ERC20Token token = ERC20Token(erc20ContractAddress);
41         require(token.transferFrom(msg.sender, bridgeWalletAddress, amount), "ERC20 token transfer was unsuccessful");
42         emit hasBeenSent(msg.sender, bridgeWalletAddress, target, amount, erc20ContractAddress);
43     }
44 }