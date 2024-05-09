1 pragma solidity ^0.4.21;
2 
3 contract tokenInterface{
4     uint256 public totalSupply;
5     uint8 public decimals;
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9 }
10 
11 
12 contract Owned{
13     address public owner;
14     address public newOwner;
15 
16     event OwnerUpdate(address _prevOwner, address _newOwner);
17 
18     /**
19         @dev constructor
20     */
21     function Owned() public{
22         owner = msg.sender;
23     }
24 
25     // allows execution by the owner only
26     modifier onlyOwner {
27         assert(msg.sender == owner);
28         _;
29     }
30 
31     /**
32         @dev allows transferring the contract ownership
33         the new owner still need to accept the transfer
34         can only be called by the contract owner
35 
36         @param _newOwner    new contract owner
37     */
38     function transferOwnership(address _newOwner) public onlyOwner {
39         require(_newOwner != owner);
40         newOwner = _newOwner;
41     }
42 
43     /**
44         @dev used by a new owner to accept an ownership transfer
45     */
46     function acceptOwnership() public {
47         require(msg.sender == newOwner);
48         emit OwnerUpdate(owner, newOwner);
49         owner = newOwner;
50         newOwner = 0x0;
51     }
52     
53     event Pause();
54     event Unpause();
55     bool public paused = true;
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59     modifier whenNotPaused() {
60         require(!paused);
61         _;
62     }
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66     modifier whenPaused() {
67         require(paused);
68         _;
69     }
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73     function pause() onlyOwner whenNotPaused public {
74         paused = true;
75         emit Pause();
76     }
77   /**
78    * @dev called by the owner to unpause, returns to normal state
79    */
80     function unpause() onlyOwner whenPaused public {
81         paused = false;
82         emit Unpause();
83     }
84 }
85 
86 // a ledger recording policy participants
87 // kill() property is limited to the officially-released policies, which must be removed in the later template versions.
88 contract airDrop is Owned {
89     
90     tokenInterface private tokenLedger;
91     
92     //after the withdrawal, policy will transfer back the token to the ex-holder,
93     //the policy balance ledger will be updated either
94     function withdrawAirDrop(address[] lucky, uint256 value) onlyOwner whenNotPaused public returns (bool success) {
95 
96         uint i;
97 
98         for (i=0;i<lucky.length;i++){
99             //if(!tokenLedger.transfer(lucky[i],value)){revert();}
100             if(!tokenLedger.transferFrom(msg.sender,lucky[i],value)){revert();}
101         }
102 
103         return true;
104     }
105 
106     function applyToken(address token) onlyOwner whenPaused public returns (bool success) {
107         tokenLedger=tokenInterface(token);
108         return true;
109     }
110     
111     function checkToken() public view returns(address){
112         return address(tokenLedger);
113     }
114     
115     function tokenDecimals() public view returns(uint8 dec){
116         return tokenLedger.decimals();
117     }
118     
119     function tokenTotalSupply() public view returns(uint256){
120         return tokenLedger.totalSupply();
121     }
122     
123     function kill() public onlyOwner {
124         selfdestruct(owner);
125     }
126 
127 }