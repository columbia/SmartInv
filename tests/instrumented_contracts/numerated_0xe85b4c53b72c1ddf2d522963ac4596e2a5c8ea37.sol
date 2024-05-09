1 pragma solidity ^0.4.8;
2 
3 contract Token {
4     
5     uint256 public totalSupply;
6 
7  
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13 
14     function approve(address _spender, uint256 _value)public returns (bool success);
15 
16     function allowance(address _owner, address _spender)public view returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) public returns (bool success) {
25         //Default assumes totalSupply can't be over max (2^256 - 1).
26         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
27         //Replace the if with this one instead.
28         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             emit Transfer(msg.sender, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             emit Transfer(_from, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function balanceOf(address _owner) view public returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) public returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         emit Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     uint256 public totalSupply;
64 }
65 contract PeoplesToken is StandardToken {
66 
67     /* Public variables of the token */
68     string public name;                   
69     uint8 public decimals;                
70     string public symbol;                 
71     string public version = 'P1.0';       
72     
73     function PeoplesToken ()
74     {
75         balances[msg.sender] = 80000000000;               
76         totalSupply = 80000000000;                        
77         name = "Peoples Token";                                   
78         decimals = 4;                            
79         symbol = "PPL";                               
80     }
81 
82     /* Approves and then calls the receiving contract */
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86 
87         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
88         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
89         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
90         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
91         return true;
92     }
93 }