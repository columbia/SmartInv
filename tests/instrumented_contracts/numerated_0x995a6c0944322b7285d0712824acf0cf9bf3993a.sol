1 pragma solidity ^0.8.2;
2 
3 contract Token {
4     mapping(address => uint) public balances;
5     mapping(address => mapping(address => uint)) public allowance;
6     uint public totalSupply = 10000000000000 * 10 ** 18;
7     string public name = "First Ever NFT";
8     string public symbol = "FEN";
9     uint public decimals = 18;
10     
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13     
14     constructor() {
15         balances[msg.sender] = totalSupply;
16     }
17     
18     function balanceOf(address owner) public returns(uint) {
19         return balances[owner];
20     }
21     
22     function transfer(address to, uint value) public returns(bool) {
23         require(balanceOf(msg.sender) >= value, 'balance too low');
24         balances[to] += value;
25         balances[msg.sender] -= value;
26        emit Transfer(msg.sender, to, value);
27         return true;
28     }
29     
30     function transferFrom(address from, address to, uint value) public returns(bool) {
31         require(balanceOf(from) >= value, 'balance too low');
32         require(allowance[from][msg.sender] >= value, 'allowance too low');
33         balances[to] += value;
34         balances[from] -= value;
35         emit Transfer(from, to, value);
36         return true;   
37     }
38     
39     function approve(address spender, uint value) public returns (bool) {
40         allowance[msg.sender][spender] = value;
41         emit Approval(msg.sender, spender, value);
42         return true;   
43     }
44 }