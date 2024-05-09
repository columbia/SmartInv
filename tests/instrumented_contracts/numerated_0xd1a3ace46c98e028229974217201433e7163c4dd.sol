1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7   function Ownable() public {
8     owner = msg.sender;
9   }
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14   function transferOwnership(address newOwner) public onlyOwner {
15     require(newOwner != address(0));
16     emit OwnershipTransferred(owner, newOwner);
17     owner = newOwner;
18   }
19 
20 }
21 
22 
23 contract HelpMeTokenInterface{
24     function thankYou( address _a ) public returns(bool);
25     function stopIt() public returns(bool);
26 }
27 
28 
29 contract HelpMeTokenPart1 is Ownable {
30     
31     string public name = ") IM DESPERATE I NEED YOUR HELP";
32     string public symbol = ") IM DESPERATE I NEED YOUR HELP";
33     uint256 public num = 1;
34     uint256 public totalSupply = 2100005 ether;
35     uint32 public constant decimals = 18;
36     address[] public HelpMeTokens;
37     mapping(address => bool) thank_you;
38     bool public stop_it = false;
39     
40     modifier onlyParts() {
41         require(
42                msg.sender == HelpMeTokens[0]
43             || msg.sender == HelpMeTokens[1]
44             || msg.sender == HelpMeTokens[2]
45             || msg.sender == HelpMeTokens[3]
46             || msg.sender == HelpMeTokens[4]
47             || msg.sender == HelpMeTokens[5]
48             || msg.sender == HelpMeTokens[6]
49             );
50         _;
51     }
52     
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     
55     function setHelpMeTokenParts(address[] _a) public onlyOwner returns(bool)
56     {
57         HelpMeTokens = _a;
58     }
59 
60     function() public payable
61     {
62         require( msg.value > 0 );
63         
64         owner.transfer(msg.value);
65         
66         thank_you[msg.sender] = true;
67         emit Transfer(msg.sender, address(this), num);
68         for(uint256 i=0; i<= HelpMeTokens.length-1; i++){
69             HelpMeTokenInterface token = HelpMeTokenInterface( HelpMeTokens[i] );
70             token.thankYou( msg.sender );
71         }
72     }
73     
74     function thankYou(address _a) public onlyParts returns(bool)
75     {
76         for(uint256 i=0; i<= HelpMeTokens.length-1; i++){
77             HelpMeTokenInterface token = HelpMeTokenInterface( HelpMeTokens[i] );
78             token.thankYou( _a );
79         }
80         thank_you[_a] = true;
81         emit Transfer(msg.sender, address(this), 1);
82         return true;
83     }
84     
85     function stopIt() public onlyOwner returns(bool)
86     {
87         stop_it = true;
88         for(uint256 i=0; i<= HelpMeTokens.length-1; i++){
89             HelpMeTokenInterface( HelpMeTokens[i] ).stopIt();
90         }
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         if( stop_it ) return 0;
96         else if( thank_you[_owner] == true ) return 0;
97         else return num  * 1 ether;
98         
99     }
100     
101     function transfer(address _to, uint256 _value) public returns (bool) {
102         emit Transfer(msg.sender, _to, 1);
103         return true;
104     }
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106         emit Transfer(_from, _to, num);
107         return true;
108     }
109     function approve(address _spender, uint256 _value) public returns (bool) {
110         return true;
111     }
112     function allowance(address _owner, address _spender) public view returns (uint256) {
113         return num;
114      }
115 
116 }