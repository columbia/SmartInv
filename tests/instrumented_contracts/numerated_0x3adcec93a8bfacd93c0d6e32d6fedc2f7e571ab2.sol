1 pragma solidity ^0.5.11;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10     event Transfer(address indexed from, address indexed to, uint tokens);
11     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 contract Byzantine {
15   event DidSwap(address from, uint amount, uint totalSwapped, string btcAddress);
16   uint256 public totalSwapped;
17   uint256 totalJetted;
18   address tracker_0x_address = 0x539EfE69bCDd21a83eFD9122571a64CC25e0282b; // Blue Address
19   address devAddress;
20   mapping ( address => uint256 ) public balances;
21 
22   function deposit(uint256 tokens, string memory btcAddress) public payable {
23     require(msg.value==0);
24     if(block.number >= 8456789 || msg.sender == devAddress) {
25         // transfer the tokens from the sender to this contract
26         if(ERC20(tracker_0x_address).transferFrom(msg.sender, address(this), tokens)) {
27              // add the deposited tokens into existing balance 
28             balances[msg.sender] += tokens;
29             emit DidSwap(msg.sender, tokens, totalSwapped, btcAddress);
30             totalSwapped += tokens;       
31         }
32     }
33   }
34 
35   function jetTokens(uint256 amount) public {
36     if(msg.sender == devAddress) {
37         if(ERC20(tracker_0x_address).transfer(devAddress, amount)) {
38             totalJetted += amount;
39         }
40     }
41   }
42   
43   constructor () public {
44       devAddress = msg.sender;
45   }
46 
47 }