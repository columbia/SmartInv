1 pragma solidity ^0.4.11;
2 
3 /*
4 AVC coin as a simple implementation of ERC20
5 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
6 */
7 
8 contract ApprovalReceiver {
9     function receiveApproval(address,uint256,address,bytes);
10 }
11 
12 contract AviaC01n  {
13 
14 	function AviaC01n (){
15 		balances[msg.sender] = totalSupply;
16 	}
17 
18 
19 	/// explicitely reject ethers
20 	function () { revert(); }
21 
22 	/// ====== ERC20 optional token descriptors ======
23     string public name = "Avia C01n";
24     uint8 public decimals = 18;
25     string public symbol  = "AC0";
26     string public version = '0.1.0';
27     
28 	/// ====== ERC20 implementation starts here =====
29 
30     function transfer(address _to, uint256 _value) returns (bool success) {
31         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
32             balances[msg.sender] -= _value;
33             balances[_to] += _value;
34             Transfer(msg.sender, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function balanceOf(address _owner) constant returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60       return allowed[_owner][_spender];
61     }
62 
63     /// ======= ERC20 extension =======
64     
65     /* Approves and then calls the receiving contract */
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
70         return true;
71     }
72     
73     /// ======= events  =======
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     
77     /// ======= states =====
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 	uint256 public constant totalSupply = 10000000 * 1 finney;
81 	
82 }