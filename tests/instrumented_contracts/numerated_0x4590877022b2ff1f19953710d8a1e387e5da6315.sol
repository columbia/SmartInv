1 pragma solidity ^0.4.24;
2 
3 // ERC20 token contract
4 
5 contract ERC20Interface {
6     function totalSupply() public constant returns (uint);
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8     function transfer(address to, uint tokens) public returns (bool success);
9 
10     event Transfer(address indexed from, address indexed to, uint tokens);
11 }
12 
13 contract MeerkatToken is ERC20Interface {
14     address public owner;
15     string public symbol;
16     string public name;
17     uint8 public decimals;
18     uint public initSupply;
19 
20     mapping(address => uint) balances;
21 
22     constructor() public {
23         owner = msg.sender;
24         symbol = "MCT";
25         name = "Meerkat Token";
26         decimals = 18;
27         initSupply = 10000000000 * 10**uint(decimals);
28         balances[owner] = initSupply;
29         
30         emit Transfer(address(0), owner, initSupply);
31     }
32 
33     function totalSupply() public constant returns (uint) {
34         return initSupply - balances[address(0)];
35     }
36 
37     function balanceOf(address tokenOwner) public constant returns (uint balance) {
38         return balances[tokenOwner];
39     }
40 
41     function transfer(address _to, uint _value) public returns (bool success) {
42         require(balances[msg.sender] >= _value);
43         require(balances[_to] + _value >= balances[_to]);
44         uint previousBalances = balances[msg.sender] + balances[_to];
45 
46         balances[msg.sender] -= _value;
47         balances[_to] += _value;
48         
49         emit Transfer(msg.sender, _to, _value);
50         assert(balances[msg.sender] + balances[_to] == previousBalances);
51         
52         return true;
53     }
54 
55     function () public payable {
56         revert();
57     }
58 
59 }