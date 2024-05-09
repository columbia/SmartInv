1 /**
2 * solc --abi  RootCoin.sol > ./RootCoin.abi
3 **/
4 pragma solidity 0.4.18;
5 
6 contract RootCoin {
7     mapping(address => uint256) balances;
8     mapping(address => mapping (address => uint256)) allowed;
9     uint256 _totalSupply = 250000000000;
10     address public owner;
11     string public constant name = "Root Blockchain";
12     string public constant symbol = "RBC";
13     uint8 public constant decimals = 2;
14 
15     function RootCoin(){
16         balances[msg.sender] = _totalSupply;
17     }
18 
19     function totalSupply() constant returns (uint256 theTotalSupply) {
20         theTotalSupply = _totalSupply;
21         return theTotalSupply;
22     }
23 
24     function balanceOf(address _owner) constant returns (uint256 balance) {
25         return balances[_owner];
26     }
27 
28     function approve(address _spender, uint256 _amount) returns (bool success) {
29         allowed[msg.sender][_spender] = _amount;
30         Approval(msg.sender, _spender, _amount);
31         return true;
32     }
33 
34     function transfer(address _to, uint256 _amount) returns (bool success) {
35         if (balances[msg.sender] >= _amount && _amount > 0) {
36             balances[msg.sender] -= _amount;
37             balances[_to] += _amount;
38 
39             Transfer(msg.sender, _to, _amount);
40             return true;
41         } else {
42             return false;
43         }
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
47         if (balances[_from] >= _amount
48         && allowed[_from][msg.sender] >= _amount
49         && _amount > 0
50         && balances[_to] + _amount > balances[_to]) {
51             balances[_from] -= _amount;
52             balances[_to] += _amount;
53             Transfer(_from, _to, _amount);
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61         return allowed[_owner][_spender];
62     }
63 
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 }