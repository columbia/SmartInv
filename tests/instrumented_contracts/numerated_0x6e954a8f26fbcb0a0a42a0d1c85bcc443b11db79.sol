1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 pragma solidity ^0.8.7;
5 
6 contract ShibNitro {
7     
8     string public constant name = "ShibNitro";
9     string public constant symbol = "SHIN";
10     uint8 public constant decimals = 18;
11     
12     event Transfer(address indexed from, address indexed to, uint tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14     uint256 totalsupply;
15     
16     mapping(address => uint256) balances;
17     mapping(address => mapping (address => uint256)) allowed;
18     
19     constructor(){
20         
21         totalsupply = 420690690690 * 10 ** decimals;
22         balances[msg.sender] = totalsupply;
23     }
24     
25     function totalSupply() public view returns (uint256) {
26         
27         return totalsupply;
28     }
29     
30     function balanceOf(address tokenOwner) public view returns (uint){
31         
32         return balances[tokenOwner];
33     }
34     
35     function transfer(address receiver, uint numTokens) public returns(bool){
36         require(numTokens <= balances[msg.sender]);
37         balances[msg.sender] = balances[msg.sender] - numTokens;
38         balances[receiver] = balances[receiver] + numTokens;
39         emit Transfer(msg.sender, receiver, numTokens);
40         return true;
41     }
42     
43     function approve(address delegate, uint numTokens) public returns (bool){
44         
45         allowed[msg.sender][delegate] = numTokens;
46         emit Approval(msg.sender, delegate, numTokens);
47         return true;
48     }
49     
50     function allowance(address owner, address delegate) public view returns (uint){
51         
52         return allowed[owner][delegate];
53         
54     }
55     
56     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool){
57         require(numTokens <= balances[owner]);
58         require(numTokens <= allowed[owner][msg.sender]);
59         balances[owner] = balances[owner] - numTokens;
60         allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
61         balances[buyer] = balances[buyer] + numTokens;
62         emit Transfer(owner, buyer, numTokens);
63         return true;
64         
65     }
66  }