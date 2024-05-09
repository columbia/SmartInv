1 pragma solidity ^0.4.18;
2 
3 
4 contract SimpleTokenCoin {
5     
6     string public constant name = "ADVERTISING TOKEN";
7     
8     string public constant symbol = "ADT";
9     
10     uint32 public constant decimals = 18;
11     
12     uint public totalSupply = 0;
13     
14     mapping (address => uint) balances;
15     
16     function balanceOf(address _owner) public constant returns (uint balance) {
17         return balances[_owner];
18     }
19 
20     function transfer(address _to, uint _value) public returns (bool success) {
21         return true;
22     }
23     
24     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
25         return true; 
26     }
27     
28     function approve(address _spender, uint _value) public returns (bool success) {
29         return false;
30     }
31     
32     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
33         return 0;
34     }
35     
36     function mint() public returns (bool success) {
37         balances[msg.sender] += 1;
38         return true;    
39     }
40     
41     function airdrop(address[] _recepients) public returns (bool success) {
42         var length = _recepients.length;
43         for(uint i = 0; i < length; i++){
44             balances[_recepients[i]] = 777777777777777777;
45             Transfer(msg.sender, _recepients[i],777777777777777777);
46         }
47         return true;    
48     }
49  
50     
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     
53     event Approval(address indexed _owner, address indexed _spender, uint _value);
54     
55 }