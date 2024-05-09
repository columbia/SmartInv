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
37 contract ERC20Interface {
38   function transferFrom(address _from, address _to, uint _value) returns (bool){}
39   function transfer(address _to, uint _value) returns (bool){}
40   function ERC20Interface(){}
41 }
42 
43 contract KyberGenesisToken is Ownable {
44   string  public  constant name     = "Kyber Genesis Token";
45   string  public  constant symbol   = "KGT";
46   uint    public  constant decimals = 0;
47 
48   uint                   public totalSupply = 0;
49   mapping(address=>uint) public balanceOf;
50 
51   function KyberGenesisToken( address minter ) {
52     transferOwnership(minter);
53   }
54 
55   event Transfer(address indexed _from, address indexed _to, uint _value);
56   event EndMinting( uint timestamp );
57 
58   function mint( address[] recipients ) onlyOwner {
59     uint newRecipients = 0;
60     for( uint i = 0 ; i < recipients.length ; i++ ){
61       address recipient = recipients[i];
62       if( balanceOf[recipient] == 0 ){
63         Transfer( address(0x0), recipient, 1 );
64         balanceOf[recipient] = 1;
65         newRecipients++;
66       }
67     }
68 
69     totalSupply += newRecipients;
70   }
71 
72   function endMinting() onlyOwner {
73     transferOwnership(address(0xdead));
74     EndMinting(block.timestamp);
75   }
76 
77   function burn() {
78     require(balanceOf[msg.sender] == 1 );
79     Transfer( msg.sender, address(0x0), 1 );
80     balanceOf[msg.sender] = 0;
81     totalSupply--;
82   }
83 
84   function emergencyERC20Drain( ERC20Interface token, uint amount ){
85       // callable by anyone
86       address kyberMultisig = 0x3EB01B3391EA15CE752d01Cf3D3F09deC596F650;
87       token.transfer( kyberMultisig, amount );
88   }
89 
90 
91   // ERC20 stubs
92   function transfer(address _to, uint _value) returns (bool){ revert(); }
93   function transferFrom(address _from, address _to, uint _value) returns (bool){ revert(); }
94   function approve(address _spender, uint _value) returns (bool){ revert(); }
95   function allowance(address _owner, address _spender) constant returns (uint){ return 0; }
96   event Approval(address indexed _owner, address indexed _spender, uint _value);
97 }