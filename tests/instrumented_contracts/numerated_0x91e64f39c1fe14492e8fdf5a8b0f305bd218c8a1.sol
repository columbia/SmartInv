1 pragma solidity 0.5.0;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * @notice Renouncing to ownership will leave the contract without an owner.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 interface IERC20 {
81     function transfer(address to, uint256 value) external returns (bool);
82 
83     function approve(address spender, uint256 value) external returns (bool);
84 
85     function transferFrom(address from, address to, uint256 value) external returns (bool);
86 
87     function totalSupply() external view returns (uint256);
88 
89     function balanceOf(address who) external view returns (uint256);
90 
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @title ControlCentreInterface
101  * @dev ControlCentreInterface is an interface for providing commonly used function
102  * signatures to the ControlCentre
103  */
104 interface IController {
105 
106     function totalSupply() external view returns (uint256);
107     function balanceOf(address _owner) external view returns (uint256);
108     function allowance(address _owner, address _spender) external view returns (uint256);
109 
110     function approve(address owner, address spender, uint256 value) external returns (bool);
111     function transfer(address owner, address to, uint value) external returns (bool);
112     function transferFrom(address owner, address from, address to, uint256 amount) external returns (uint256);
113     function mint(address _to, uint256 _amount)  external returns (bool);
114 
115     function increaseAllowance(address owner, address spender, uint256 addedValue) external returns (uint256);
116     function decreaseAllowance(address owner, address spender, uint256 subtractedValue) external returns (uint256);
117 
118     function burn(address owner, uint value) external returns (bool);
119     function burnFrom(address spender, address from, uint value) external returns (uint256);
120 }
121 
122 
123 contract ERC20 is Ownable, IERC20 {
124 
125     event Mint(address indexed to, uint256 amount);
126     event Log(address to);
127     event MintToggle(bool status);
128     
129     // Constant Functions
130     function balanceOf(address _owner) public view returns (uint256) {
131         return IController(owner()).balanceOf(_owner);
132     }
133 
134     function totalSupply() public view returns (uint256) {
135         return IController(owner()).totalSupply();
136     }
137 
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139         return IController(owner()).allowance(_owner, _spender);
140     }
141 
142     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
143         emit Mint(_to, _amount);
144         emit Transfer(address(0), _to, _amount);
145         return true;
146     }
147 
148     function mintToggle(bool status) public onlyOwner returns (bool) {
149         emit MintToggle(status);
150         return true;
151     }
152 
153     // public functions
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         IController(owner()).approve(msg.sender, _spender, _value);
156         emit Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
161         uint256 allowed = IController(owner()).increaseAllowance(msg.sender, spender, addedValue);
162         emit Approval(msg.sender, spender, allowed);
163         return true;
164     }
165     
166     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
167         uint256 allowed = IController(owner()).decreaseAllowance(msg.sender, spender, subtractedValue);
168         emit Approval(msg.sender, spender, allowed);
169         return true;
170     }
171 
172     function transfer(address to, uint value) public returns (bool) {
173         IController(owner()).transfer(msg.sender, to, value);
174         emit Transfer(msg.sender, to, value);
175         return true;
176     }
177 
178     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
179         uint256 allowed = IController(owner()).transferFrom(msg.sender, _from, _to, _amount);
180         emit Approval(_from, msg.sender, allowed);
181         emit Transfer(_from, _to, _amount);
182         return true;
183     }
184 
185     function burn(uint256 value) public returns (bool) {
186         IController(owner()).burn(msg.sender, value);
187         emit Transfer(msg.sender, address(0), value);
188         return true;
189     }
190 
191     function burnFrom(address from, uint256 value) public returns (bool) {
192         uint256 allowed = IController(owner()).burnFrom(msg.sender, from, value);
193         emit Approval(from, msg.sender, allowed);
194         emit Transfer(from, address(0), value);
195         return true;
196     }
197 }
198 
199 
200 contract VodiX is ERC20 {
201 
202     string internal _name = "Vodi X";
203     string internal _symbol = "VDX";
204     uint8 internal _decimals = 18;
205 
206     /**
207      * @return the name of the token.
208      */
209     function name() public view returns (string memory) {
210         return _name;
211     }
212 
213     /**
214      * @return the symbol of the token.
215      */
216     function symbol() public view returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @return the number of decimals of the token.
222      */
223     function decimals() public view returns (uint8) {
224         return _decimals;
225     }
226 }