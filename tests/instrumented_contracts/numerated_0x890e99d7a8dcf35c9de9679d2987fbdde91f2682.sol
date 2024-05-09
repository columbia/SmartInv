1 pragma solidity ^0.4.13;
2 
3 
4 contract Token {   
5     uint256 public totalSupply;
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract StandardToken is Token {
16     mapping (address => uint256) balances;
17     mapping (address => mapping (address => uint256)) allowed;
18 
19     function transfer(address _to, uint256 _value) public returns (bool success) {       
20         address sender = msg.sender;
21         require(balances[sender] >= _value);
22         balances[sender] -= _value;
23         balances[_to] += _value;
24         Transfer(sender, _to, _value);
25         return true;
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {      
29         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
30         balances[_to] += _value;
31         balances[_from] -= _value;
32         allowed[_from][msg.sender] -= _value;
33         Transfer(_from, _to, _value);
34         return true;
35     }
36 
37     function balanceOf(address _owner) public constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) public returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
48       return allowed[_owner][_spender];
49     }    
50 }
51 
52 contract GigaGivingToken is StandardToken {
53     string public constant NAME = "Giga Coin";
54     string public constant SYMBOL = "GC";
55     uint256 public constant DECIMALS = 0;
56     uint256 public constant TOTAL_TOKENS = 15000000;
57     uint256 public constant  CROWDSALE_TOKENS = 12000000;  
58     string public constant VERSION = "GC.2";
59 
60     function GigaGivingToken () public {
61         balances[msg.sender] = TOTAL_TOKENS; 
62         totalSupply = TOTAL_TOKENS;
63     }
64     
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
69         return true;
70     }
71 }