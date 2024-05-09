1 pragma solidity ^0.4.24;
2 
3 
4 interface DelegatedERC20 {
5     function allowance(address _owner, address _spender) external view returns (uint256); 
6     function transferFrom(address from, address to, uint256 value, address sender) external returns (bool); 
7     function approve(address _spender, uint256 _value, address sender) external returns (bool);
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address _owner) external view returns (uint256);
10     function transfer(address _to, uint256 _value, address sender) external returns (bool);
11 }
12 
13 
14 
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * See https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address _who) public view returns (uint256);
23   function transfer(address _to, uint256 _value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 
28 
29 
30 
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/20
35  */
36 contract ERC20 is ERC20Basic {
37   function allowance(address _owner, address _spender)
38     public view returns (uint256);
39 
40   function transferFrom(address _from, address _to, uint256 _value)
41     public returns (bool);
42 
43   function approve(address _spender, uint256 _value) public returns (bool);
44   event Approval(
45     address indexed owner,
46     address indexed spender,
47     uint256 value
48   );
49 }
50 
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 
116 /**
117  * @title TokenFront is intended to provide a permanent address for a
118  * restricted token.  Systems which intend to use the token front should not
119  * emit ERC20 events.  Rather this contract should emit them. 
120  */
121 contract TokenFront is ERC20, Ownable {
122 
123     string public name = "Test Fox Token";
124     string public symbol = "TFT";
125 
126     DelegatedERC20 public tokenLogic;
127     
128     constructor(DelegatedERC20 _tokenLogic, address _owner) public {
129         owner = _owner;
130         tokenLogic = _tokenLogic; 
131     }
132 
133     function migrate(DelegatedERC20 newTokenLogic) public onlyOwner {
134         tokenLogic = newTokenLogic;
135     }
136 
137     function allowance(address owner, address spender) 
138         public 
139         view 
140         returns (uint256)
141     {
142         return tokenLogic.allowance(owner, spender);
143     }
144 
145     function transferFrom(address from, address to, uint256 value) public returns (bool) {
146         if (tokenLogic.transferFrom(from, to, value, msg.sender)) {
147             emit Transfer(from, to, value);
148             return true;
149         } 
150         return false;
151     }
152 
153     function approve(address spender, uint256 value) public returns (bool) {
154         if (tokenLogic.approve(spender, value, msg.sender)) {
155             emit Approval(msg.sender, spender, value);
156             return true;
157         }
158         return false;
159     }
160 
161     function totalSupply() public view returns (uint256) {
162         return tokenLogic.totalSupply();
163     }
164     
165     function balanceOf(address who) public view returns (uint256) {
166         return tokenLogic.balanceOf(who);
167     }
168 
169     function transfer(address to, uint256 value) public returns (bool) {
170         if (tokenLogic.transfer(to, value, msg.sender)) {
171             emit Transfer(msg.sender, to, value);
172             return true;
173         } 
174         return false;
175     }
176 
177 }