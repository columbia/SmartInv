1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 contract KyberAirDrop is Ownable {
38   uint public numDrops;
39   uint public dropAmount;
40 
41   function KyberAirDrop( address dropper ) {
42     transferOwnership(dropper);
43   }
44 
45   event TokenDrop( address receiver, uint amount );
46   function airDrop( ERC20Interface token,
47                     address   tokenRepo,
48                     address[] recipients,
49                     uint amount,
50                     bool kgt,
51                     KyberGenesisToken kgtToken ) onlyOwner {
52     require( amount == 0 || amount == (2*(10**18)) || amount == (5*(10**18)) );
53 
54     if( amount > 0 ) {
55       for( uint i = 0 ; i < recipients.length ; i++ ) {
56           assert( token.transferFrom( tokenRepo, recipients[i], amount ) );
57           TokenDrop( recipients[i], amount );
58       }
59     }
60 
61     if( kgt ) {
62       kgtToken.mint(recipients);
63     }
64 
65     numDrops += recipients.length;
66     dropAmount += recipients.length * amount;
67   }
68 
69   function tranferMinterOwnership( KyberGenesisToken kgtToken, address newOwner ) onlyOwner {
70     kgtToken.transferOwnership(newOwner);
71   }
72 
73   function emergencyERC20Drain( ERC20Interface token, uint amount ) {
74       // callable by anyone
75       address kyberMultisig = 0x3EB01B3391EA15CE752d01Cf3D3F09deC596F650;
76       token.transfer( kyberMultisig, amount );
77   }
78 }
79 
80 contract KyberGenesisToken is Ownable {
81   string  public  constant name     = "Kyber Genesis Token";
82   string  public  constant symbol   = "KGT";
83   uint    public  constant decimals = 0;
84 
85   uint                   public totalSupply = 0;
86   mapping(address=>uint) public balanceOf;
87 
88   function KyberGenesisToken( address minter ) {
89     transferOwnership(minter);
90   }
91 
92   event Transfer(address indexed _from, address indexed _to, uint _value);
93   event EndMinting( uint timestamp );
94 
95   function mint( address[] recipients ) onlyOwner {
96     uint newRecipients = 0;
97     for( uint i = 0 ; i < recipients.length ; i++ ){
98       address recipient = recipients[i];
99       if( balanceOf[recipient] == 0 ){
100         Transfer( address(0x0), recipient, 1 );
101         balanceOf[recipient] = 1;
102         newRecipients++;
103       }
104     }
105 
106     totalSupply += newRecipients;
107   }
108 
109   function endMinting() onlyOwner {
110     transferOwnership(address(0xdead));
111     EndMinting(block.timestamp);
112   }
113 
114   function burn() {
115     require(balanceOf[msg.sender] == 1 );
116     Transfer( msg.sender, address(0x0), 1 );
117     balanceOf[msg.sender] = 0;
118     totalSupply--;
119   }
120 
121   function emergencyERC20Drain( ERC20Interface token, uint amount ){
122       // callable by anyone
123       address kyberMultisig = 0x3EB01B3391EA15CE752d01Cf3D3F09deC596F650;
124       token.transfer( kyberMultisig, amount );
125   }
126 
127 
128   // ERC20 stubs
129   function transfer(address _to, uint _value) returns (bool){ revert(); }
130   function transferFrom(address _from, address _to, uint _value) returns (bool){ revert(); }
131   function approve(address _spender, uint _value) returns (bool){ revert(); }
132   function allowance(address _owner, address _spender) constant returns (uint){ return 0; }
133   event Approval(address indexed _owner, address indexed _spender, uint _value);
134 }
135 
136 contract ERC20Interface {
137   function transferFrom(address _from, address _to, uint _value) returns (bool){}
138   function transfer(address _to, uint _value) returns (bool){}
139   function ERC20Interface(){}
140 }