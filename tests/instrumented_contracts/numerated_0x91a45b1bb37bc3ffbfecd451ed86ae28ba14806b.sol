1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface ERC20 {
9   function decimals() public constant returns (uint8 decimals);
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 contract LibraCreditNetwork is ERC20 {    		
22 		
23   string public _name;
24   string public _symbol;
25   uint8 public _decimals;
26   uint256 _totalSupply; 
27   
28   string private _version = '0.1';
29   
30   mapping(address => uint256) balances;
31   mapping (address => mapping (address => uint256)) internal allowed;
32   
33   function () {
34         //if ether is sent to this address, send it back.
35         throw;
36   }
37   	
38   function LibraCreditNetwork() {                           
39         _name = "Libra Credit Network";            
40         _symbol = "LBA";                                    
41         _decimals = 18;                  		
42         _totalSupply = 1000000000000000000000000000; 
43         balances[msg.sender] = _totalSupply;
44   }
45   
46   /**
47   * @dev decimal number
48   */
49   function decimals() public constant returns (uint8 decimals) {
50         return _decimals;
51   }
52   
53   /**
54   * @dev LBA token contract version
55   */
56   function version() public view returns (string) {
57         return _version;
58   }
59 
60   /**
61   * @dev total number of tokens in existence
62   */
63   function totalSupply() public view returns (uint256) {
64     return _totalSupply;
65   }
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] -= _value;
78     balances[_to] += _value;
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91   
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    */
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[_from]);
101     require(_value <= allowed[_from][msg.sender]);
102 
103     balances[_from] -= _value;
104     balances[_to] += _value;
105     allowed[_from][msg.sender] -= _value;
106     Transfer(_from, _to, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112    *
113    * Beware that changing an allowance with this method brings the risk that someone may use both the old
114    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
115    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
116    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117    * @param _spender The address which will spend the funds.
118    * @param _value The amount of tokens to be spent.
119    */
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     allowed[msg.sender][_spender] = _value;
122     Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Function to check the amount of tokens that an owner allowed to a spender.
128    * @param _owner address The address which owns the funds.
129    * @param _spender address The address which will spend the funds.
130    * @return A uint256 specifying the amount of tokens still available for the spender.
131    */
132   function allowance(address _owner, address _spender) public view returns (uint256) {
133     return allowed[_owner][_spender];
134   }
135 }