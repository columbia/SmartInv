1 pragma solidity ^0.4.16;
2 contract Ownable {
3     address public owner;
4 
5         modifier onlyOwner() { //This modifier is for checking owner is calling
6         if (owner == msg.sender) {
7             _;
8         } else {
9             revert();
10         }
11 
12     }
13 
14 }
15 
16 contract Mortal is Ownable {
17     
18     function kill()  public{
19         if (msg.sender == owner)
20             selfdestruct(owner);
21     }
22 }
23 
24 contract Token {
25     uint256 public totalSupply;
26     uint256 tokensForICO;
27     uint256 etherRaised;
28 
29     function balanceOf(address _owner)public constant returns(uint256 balance);
30 
31     function transfer(address _to, uint256 _tokens) public returns(bool resultTransfer);
32 
33     function transferFrom(address _from, address _to, uint256 _tokens) public returns(bool resultTransfer);
34 
35     function approve(address _spender, uint _value)public returns(bool success);
36 
37     function allowance(address _owner, address _spender)public constant returns(uint remaining);
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 }
41 contract Pausable is Ownable {
42   event Pause();
43   event Unpause();
44 
45   bool public paused = false;
46 
47 
48   /**
49    * @dev modifier to allow actions only when the contract IS paused
50    */
51   modifier whenNotPaused() {
52     require(!paused);
53     _;
54   }
55 
56   /**
57    * @dev modifier to allow actions only when the contract IS NOT paused
58    */
59   modifier whenPaused() {
60     require(paused);
61     _;
62   }
63 
64   /**
65    * @dev called by the owner to pause, triggers stopped state
66    */
67   function pause()public onlyOwner whenNotPaused {
68     paused = true;
69     Pause();
70   }
71 
72   /**
73    * @dev called by the owner to unpause, returns to normal state
74    */
75   function unpause()public onlyOwner whenPaused {
76     paused = false;
77     Unpause();
78   }
79 }
80 contract StandardToken is Token,Mortal,Pausable {
81     
82     function transfer(address _to, uint256 _value)public whenNotPaused returns (bool success) {
83         require(_to!=0x0);
84         require(_value>0);
85          if (balances[msg.sender] >= _value) {
86             balances[msg.sender] -= _value;
87             balances[_to] += _value;
88             Transfer(msg.sender, _to, _value);
89             return true;
90         } else { return false; }
91     }
92 
93     function transferFrom(address _from, address _to, uint256 totalTokensToTransfer)public whenNotPaused returns (bool success) {
94         require(_from!=0x0);
95         require(_to!=0x0);
96         require(totalTokensToTransfer>0);
97     
98        if (balances[_from] >= totalTokensToTransfer&&allowance(_from,_to)>=totalTokensToTransfer) {
99             balances[_to] += totalTokensToTransfer;
100             balances[_from] -= totalTokensToTransfer;
101             allowed[_from][msg.sender] -= totalTokensToTransfer;
102             Transfer(_from, _to, totalTokensToTransfer);
103             return true;
104         } else { return false; }
105     }
106 
107     function balanceOf(address _owner)public constant returns (uint256) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value)public returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
118       return allowed[_owner][_spender];
119     }
120    
121     mapping (address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123 }
124 contract Care is StandardToken{
125     string public constant name = "CareX";
126     uint256 public constant decimals = 2;
127     string public constant symbol = "CARE";
128 
129     function Care() public{
130        totalSupply=100000000 * (10 ** decimals);  //Hunderd Million
131        owner = msg.sender;
132        balances[msg.sender] = totalSupply;
133        
134     }
135     /**
136      * @dev directly send ether and transfer token to that account 
137      */
138     function() public {
139        revert(); //we will not acept ether directly
140         
141     }
142 }