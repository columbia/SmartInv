1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4   interface :
5  */
6 interface tokenRecipient{
7   function receiveApproval(address _from, uint256 _value,  address _token,   bytes calldata _extraData) external;
8 }
9 
10 
11 contract owned{
12   //the token owner
13   address public owner;
14   
15   constructor() public{
16       owner = msg.sender;
17   }
18 
19   modifier onlyOwner {
20     require(msg.sender == owner);
21     _;
22   }
23 }
24 
25 
26 contract Coezal is owned {
27     string public name;  //token name
28     string public symbol; //token symbol
29     uint8 public decimals = 18; //Tokens to support the number of decimal digits
30     uint256 public totalSupply; //token total nums
31 
32     mapping (address => uint256) public balanceOf;//mapping address balance
33     mapping (address => mapping(address => uint256)) public allowance;//
34     mapping (address => bool) public frozenAccount;//
35 
36     event Transfer(address indexed from, address indexed to, uint256 value); //transfer event
37     event Approval(address indexed _owner,address indexed _spender,uint256 _value);
38     event Burn(address indexed from, uint256 value);
39     event FrozenFunds(address target, bool frozen);
40 
41    
42     constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
43        totalSupply = initialSupply * 10 ** uint256(decimals);
44        balanceOf[msg.sender] = totalSupply;
45        name = tokenName;
46        symbol = tokenSymbol; 
47     }
48 
49     /**
50       freeze or unfreeze account
51      */
52     function freezeAccount(address target, bool freeze) onlyOwner public {
53       frozenAccount[target] = freeze;
54       emit FrozenFunds(target,freeze);
55     }
56 
57     /**
58        Internal transfer,only can be called by this contract 
59      */
60     function _transfer(address _from,address _to, uint _value) internal{
61       require(_to != address(0x0));
62       require(_from != address(0x0));
63       require(balanceOf[_from] >= _value); //check if the sender has enough
64       require(balanceOf[_to] + _value >= balanceOf[_to]);//check for overflows
65       require(!frozenAccount[_from]);
66       require(!frozenAccount[_to]);
67 
68       uint previousBalances = balanceOf[_from] + balanceOf[_to];
69       balanceOf[_from] -= _value;
70       balanceOf[_to] += _value;
71       emit Transfer(_from, _to, _value); //send transfer event
72       // the  num mast equals after transfer
73       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77       send '_value' tokens to '_to' from your account
78      */
79     function transfer(address _to , uint256 _value) public  returns(bool success){
80       _transfer(msg.sender, _to, _value);
81       return true;
82     }
83     
84     /**
85         send '_value' tokens to '_to' on behalf to '_from'
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
88       require(_value <= allowance[_from][msg.sender]);
89       allowance[_from][msg.sender] -= _value;
90       _transfer(_from, _to, _value); 
91       return true;
92     }
93 
94     /**
95      * 
96       set allowance for other address
97       allows '_spender' to spend no more than '_value' tokens on you behalf
98      */
99     function approve(address _spender, uint256 _value)  public returns (bool success) {
100       allowance[msg.sender][_spender] = _value;
101       emit Approval(msg.sender, _spender, _value);     
102       return true;
103     }
104 
105     /**
106      set allowance for other address and nofity
107 
108      allows '_spender' to spend no more than '_value' tokens on you behalf,and then ping the contract about it
109      */
110     function approveAndCall(address _spender,uint256 _value, bytes memory _extraData) public returns (bool success) {
111       tokenRecipient spender = tokenRecipient(_spender);
112       if(approve(_spender,_value)){
113         spender.receiveApproval(msg.sender, _value, address(this),_extraData);
114         return true;
115       }
116     }
117     
118     /**
119       Destroy tokens
120       remove '_value' tokens from the system irreversibly
121      */
122     function burn(uint256 _value) onlyOwner public returns (bool success) {
123       require(balanceOf[msg.sender] >= _value);
124       balanceOf[msg.sender] -= _value;
125       totalSupply -= _value;
126       emit Burn(msg.sender, _value);
127       return true;
128     }
129     
130     /**
131      destroy tokens from other account
132      remove '_value' tokens from the system irreversibly or '_from' 
133     */
134     function burnFrom(address _from, uint256 _value) onlyOwner public returns(bool success){
135       require(balanceOf[_from] >= _value);
136       require(_value <= allowance[_from][msg.sender]);
137       balanceOf[_from] -= _value;
138       allowance[_from][msg.sender] -= _value;
139       totalSupply -= _value;
140       emit Burn(_from, _value);
141       return true;
142     }
143 }