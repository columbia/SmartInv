1 pragma solidity ^0.4.16;
2 contract owned{
3    address public owner;
4    function owned(){
5       owner=msg.sender;
6    }
7   modifier onlyOwner{
8       if(msg.sender!=owner) throw;
9       _; 
10   }
11   function transferOwnership(address newOwner) onlyOwner{
12       owner=newOwner;
13   }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 contract TokenERC20 is owned{
18     string public standard='Token 0.1';
19     string public name;
20     string public symbol;
21     uint8 public decimals = 18;
22     uint256 public totalSupply;
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25     mapping (address => bool)    public frozenAccount;
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29     event FrozenFunds(address target,bool frozen);
30 
31     function TokenERC20(
32         uint256 initialSupply,
33         string tokenName,
34         string tokenSymbol
35     ) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);
37         balanceOf[msg.sender] = totalSupply;
38         name = tokenName;
39         symbol = tokenSymbol;
40     }
41     function _transfer(address _from, address _to, uint _value) internal {
42         require(_to != 0x0);
43         require(balanceOf[_from] >= _value);
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         if (frozenAccount[_from]) throw;
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52     function transfer(address _to, uint256 _value) public {
53         _transfer(msg.sender, _to, _value);
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         if (frozenAccount[_from]) throw;
58         require(_value <= allowance[_from][msg.sender]);
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63     function approve(address _spender, uint256 _value) public  returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         return true;
66     }
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public  returns (bool success) {
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74     function burn(uint256 _value) public returns (bool success) {
75         require(balanceOf[msg.sender] >= _value);
76         balanceOf[msg.sender] -= _value;
77         totalSupply -= _value;
78         Burn(msg.sender, _value);
79         return true;
80     }
81     function burnFrom(address _from, uint256 _value) public returns (bool success) {
82         require(balanceOf[_from] >= _value);
83         require(_value <= allowance[_from][msg.sender]);
84         balanceOf[_from] -= _value;
85         allowance[_from][msg.sender] -= _value;
86         totalSupply -= _value;
87         Burn(_from, _value);
88         return true;
89     }
90 
91     function mintToke(address target,uint256 mintedAmount) onlyOwner{
92         balanceOf[target] +=mintedAmount;
93         totalSupply +=mintedAmount;
94         Transfer(0,this,mintedAmount);
95         Transfer(this,target,mintedAmount);
96     }    
97    
98     function freezeAccount(address target,bool freeze) onlyOwner{
99         frozenAccount[target]=freeze;
100         FrozenFunds(target,freeze);
101     }
102 
103     function(){
104          throw;
105      }
106 }