1 pragma solidity ^0.4.25;
2 
3 
4 contract ERC20 {
5     function totalSupply() public constant returns (uint);
6     function balanceOf(address tokenOwner) public constant returns (uint balance);
7     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
8     function transfer(address to, uint tokens) public returns (bool success);
9     function approve(address spender, uint tokens) public returns (bool success);
10     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13    
14 }
15 
16 contract Escrow {
17   
18   event Deposit(uint tokens);
19   address dai_0x_address = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359; // ContractA Address
20   mapping ( address => uint256 ) public balances;
21 
22   function deposit(uint tokens) public returns (bool success){
23     // add the deposited tokens into existing balance 
24     balances[msg.sender]+= tokens;
25     // transfer the tokens from the sender to this contract
26     ERC20(dai_0x_address).transferFrom(msg.sender, address(this), tokens);
27     emit Deposit(tokens);
28     return true;
29   }
30 
31   function returnTokens() public {
32     balances[msg.sender] = 0;
33     ERC20(dai_0x_address).transfer(msg.sender, balances[msg.sender]);
34   }
35 
36   function withdraw(uint256 tokens) public {
37         require(balances[msg.sender] >= tokens);
38         ERC20(dai_0x_address).transfer(msg.sender, tokens);
39   }
40   
41   function reallocate(address to, uint256 tokens) internal {
42         require(balances[msg.sender] >= tokens, "Insufficient balance.");
43         balances[msg.sender] -= tokens;
44         balances[to] += tokens;
45    }
46 
47 }