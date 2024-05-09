1 pragma solidity ^0.4.2;
2 
3 contract Evocoin{
4 
5   string public constant name = "Evocoin transit";
6   string public constant symbol = "EVCTS";
7   uint8 public constant decimals = 5;
8   uint public constant totalSupply = 7500000000*10**5;
9   uint userIndex = 0;
10   address public constant owner = 0x34A4933de38bF3830C7848aBb182d553F5a5D523;
11   
12   struct user{
13     address _adress;
14     uint _value;
15   }
16 
17   mapping (address => mapping (address => uint)) allowed;
18   mapping (address => uint) balances;
19   mapping (uint => user) users;
20     
21   function Evocoin() public {
22     balances[owner] = totalSupply;
23     Transfer(address(this), owner, totalSupply);
24   }
25 
26   function transferFrom(address _from, address _to, uint _value) public {
27     require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
28     require(_to != address(0x0));
29     
30     balances[_to] +=_value;
31     balances[_from] -= _value;
32     allowed[_from][msg.sender] -= _value;
33     
34     Transfer(_from, _to, _value);
35   }
36 
37   function approve(address _spender, uint _value) public {
38     allowed[msg.sender][_spender] = _value;
39     Approval(msg.sender, _spender, _value);
40   }
41 
42   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
43     return allowed[_owner][_spender];
44   }
45 
46   function transfer(address _to, uint _value) public {
47     require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
48     require(_to != address(0x0));
49     
50     balances[msg.sender] -= _value;
51     balances[_to] += _value;
52     Transfer(msg.sender, _to, _value);
53   }
54 
55   function balanceOf(address _owner) public constant returns (uint balance) {
56     return balances[_owner];
57   }
58   
59   function buyout() public { 
60     require(msg.sender!=owner);
61     require(balances[msg.sender] > 0);
62     
63     uint _value = balances[msg.sender];
64     balances[msg.sender] = 0;
65     balances[owner] += _value;
66     
67     users[userIndex]._adress = msg.sender;
68     users[userIndex]._value = _value;
69     ++userIndex;
70     
71     Transfer(msg.sender, owner, _value);
72   }
73   
74   function getTransferedUser(uint _id) public view returns(address, uint){
75     return (users[_id]._adress, users[_id]._value);
76   }
77   
78   function isTransferedUser(address _adress) public view returns(bool){
79     uint i;
80     for(i=0; i<userIndex; i++){
81         if (users[i]._adress == _adress)
82             return true;
83     }
84     return false;
85   }
86   
87   event Transfer(address indexed from, address indexed to, uint value);
88   event Approval(address indexed owner, address indexed spender, uint value);
89 }