1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract FLEBToken{
6     
7  address public owner;
8  string public name = "FLEBToken"; //Token name
9  string public symbol = "FLB";
10  uint8 public decimals = 8;       //일반적으로 18로 많이 사용.
11  uint256 public totalSupply = 0; 
12  
13  mapping(address => uint256) balances;
14  mapping(address => mapping(address => uint256)) internal allowed; //누가 누구한테 얼마 만큼 허용 
15  
16  
17  constructor() public{
18      owner = msg.sender;
19  } 
20  
21  
22  function changeOwner(address _addr) public{
23      
24      require(owner == msg.sender);
25      owner = _addr;
26  }
27   /**
28      * Transfer tokens
29      *
30      * Send `_value` tokens to `_to` from your account
31      *
32      * @param _to The address of the recipient
33      * @param _value the amount to send
34      */
35  function transfer(address _to, uint256 _value) public returns (bool) {
36      require(_to != address(0));
37      require(_value <= balances[msg.sender]);
38      
39      balances[msg.sender] = balances[msg.sender] - _value;
40      balances[_to] = balances[_to] + _value;
41      emit Transfer(msg.sender, _to, _value);
42      
43      return true;
44 }
45 
46 function balanceOf(address _owner) public view returns (uint256 balance) {
47     return balances[_owner];
48 }
49 
50  /**
51      * Transfer tokens from other address
52      *
53      * Send `_value` tokens to `_to` on behalf of `_from`
54      *
55      * @param _from The address of the sender
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58  */
59 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
60      require(_to != address(0));
61      require(_value <= balances[_from]);
62      require(_value <= allowed[_from][msg.sender]);
63      
64      balances[_from] = balances[_from] - _value;
65      balances[_to] = balances[_to] + _value;
66      
67      allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
68      emit Transfer(_from, _to, _value);
69     
70     return true;
71 }  
72 
73 /**
74  * Set allowance for other address
75  *
76  * Allows `_spender` to spend no more than `_value` tokens on your behalf
77  *
78  * @param _spender The address authorized to spend
79  * @param _value the max amount they can spend
80  */
81 function approve(address _spender, uint256 _value) public returns (bool) {
82      allowed[msg.sender][_spender] = _value; //내가(누가)  누가 한테얼마를 허용 
83      emit Approval(msg.sender, _spender, _value);
84      
85      return true;
86 }
87 
88 function allowance(address _owner, address _spender) public view returns (uint256) {
89     return allowed[_owner][_spender];
90 }
91 
92  /**
93 * Set allowance for other address and notify
94 *
95 * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
96 *
97 * @param _spender The address authorized to spend
98 * @param _value the max amount they can spend
99 * @param _extraData some extra information to send to the approved contract
100 */
101  
102 function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public returns (bool success) {
103     
104     tokenRecipient spender = tokenRecipient(_spender);
105     if (approve(_spender, _value)) {
106         spender.receiveApproval(msg.sender, _value, this, _extraData);
107         return true;
108     }
109 }
110  
111    /**
112      * Destroy tokens
113      *
114      * Remove `_value` tokens from the system irreversibly
115      *
116      * @param _value the amount of money to burn
117      */
118  function burn(uint256 _value) public returns (bool success) {
119         require(balances[msg.sender] >= _value);   // Check if the sender has enough
120         balances[msg.sender] -= _value;            // Subtract from the sender
121         totalSupply -= _value;                      // Updates totalSupply
122         emit Burn(msg.sender, _value);
123         return true;
124   }
125   
126    /**
127      * Destroy tokens from other account
128      *
129      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
130      *
131      * @param _from the address of the sender
132      * @param _value the amount of money to burn
133      */
134  function burnFrom(address _from, uint256 _value) public returns (bool success) {
135       require(balances[_from] >= _value);                // Check if the targeted balance is enough
136       require(_value <= allowed[_from][msg.sender]);    // Check allowance
137       balances[_from] -= _value;                         // Subtract from the targeted balance
138       allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
139       totalSupply -= _value;                            // Update totalSupply
140       emit Burn(_from, _value);
141       return true;
142  }
143  
144  function mint(address _to, uint256 _amount) public returns (bool) {
145      require(msg.sender == owner);
146      
147      totalSupply = totalSupply + _amount;
148      balances[_to] = balances[_to] + _amount;
149      
150      emit Mint(_to, _amount);
151      emit Transfer(address(0), _to, _amount);
152      
153      return true;
154  }
155  
156  function mintSub(address _to,uint256 _amount) public returns (bool){
157      
158      require(msg.sender == owner);
159      require(balances[msg.sender] >= _amount && balances[msg.sender] != 0 );
160      
161      totalSupply = totalSupply - _amount;
162      balances[_to] = balances[_to] - _amount;
163      
164      emit Mint(_to,_amount);
165      emit Transfer(address(0), _to,_amount);
166      
167      return true;
168      
169  }
170  
171  event Transfer(address indexed from, address indexed to, uint256 value);
172  event Approval(address indexed owner, address indexed spender, uint256 value);
173  event Mint(address indexed to, uint256 amount); 
174  // This notifies clients about the amount burnt
175  event Burn(address indexed from, uint256 value);
176  
177 }