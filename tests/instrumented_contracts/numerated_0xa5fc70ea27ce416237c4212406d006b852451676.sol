1 pragma solidity ^0.4.8;
2 
3 pragma solidity ^0.4.8;
4 
5 contract IvanToken {
6     /* Public variables of the token */
7     string public standard = 'Token 0.1';
8     string public name = 'Ivan\'s Trackable Token';
9     string public symbol = 'ITT';
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12 
13     /* This creates an array with all balances */
14     mapping (address => uint256) public balances;
15     mapping (address => mapping (address => uint256)) public allowed;
16     
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20     function transfer(address _to, uint256 _value) returns (bool success) {
21         //Default assumes totalSupply can't be over max (2^256 - 1).
22         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
23         //Replace the if with this one instead.
24         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         //same as above. Replace this line with the following if you want to protect against wrapping uints.
35         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
36         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37             balances[_to] += _value;
38             balances[_from] -= _value;
39             allowed[_from][msg.sender] -= _value;
40             Transfer(_from, _to, _value);
41             return true;
42         } else { return false; }
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 
59     function deposit() payable returns (bool success) {
60         if (msg.value == 0) return false;
61         balances[msg.sender] += msg.value;
62         totalSupply += msg.value;
63         return true;
64     }
65     
66     function withdraw(uint256 amount) returns (bool success) {
67         if (balances[msg.sender] < amount) return false;
68         balances[msg.sender] -= amount;
69         totalSupply -= amount;
70         if (!msg.sender.send(amount)) {
71             balances[msg.sender] += amount;
72             totalSupply += amount;
73             return false;
74         }
75         return true;
76     }
77 
78 }