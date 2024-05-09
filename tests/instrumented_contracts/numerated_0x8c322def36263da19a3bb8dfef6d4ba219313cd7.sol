1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     function transfer(address receiver, uint amount) public;
5     function balanceOf(address receiver)public returns(uint);
6 }
7 
8 ///@title Axioms-Airdrops
9 ///@author  Lucasxhy & Kafcioo
10 
11 contract Axioms {
12     Airdrop [] public airdrops;
13     address public owner;
14 
15     ///@notice  Set the creator of the smart contract to be its sole owner
16     constructor () public {
17         owner = msg.sender;
18     }
19 
20 
21     ///@notice  Modifier to require a minimum amount fo ether for the function to add and airdrop
22     modifier minEth {
23         require(msg.value >= 200000000000000000); // 0.2ETH Change this to amount of eth needed for gas fee in GWEI!
24         _;
25     }
26     ///@notice  Modifier that only allows the owner to execute a function
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31     ///@notice  Creates a structure for airdrops, which stores all the necessary information for users to look up the history effectively and directly from the smart contract.
32     struct Airdrop {
33         string name;
34         uint id;
35         uint tokenAmount;
36         uint countDown;
37         uint timeStamp;
38         uint gasFeePaid;
39         uint decimals;
40         address distributor;
41         Token tokenSC;
42     }
43     ///@notice  Adds a new airdrop to the smart contract and starts the count down until it is distributed
44    function addNewAirdrop(
45    string _name,
46    uint _tokenAmount,
47    uint _countDown,
48    address  _smartContract,
49    uint _decimals
50    )
51    public
52    minEth
53    payable
54    {
55        Token t = Token(_smartContract);
56        if(t.balanceOf(this)>=_tokenAmount){
57         uint lastIndex = airdrops.length++;
58         Airdrop storage airdrop = airdrops[lastIndex];
59         airdrop.name=_name;
60         airdrop.id =lastIndex;
61         airdrop.decimals = _decimals;
62         airdrop.tokenAmount = _tokenAmount;
63         airdrop.countDown=_countDown;
64         airdrop.gasFeePaid= msg.value;
65         airdrop.timeStamp=now;
66         airdrop.distributor = msg.sender;
67         airdrop.tokenSC = Token(_smartContract);
68        }else revert('Air Drop not added, Please make sure you send your ERC20 tokens to the smart contract before adding new airdrop');
69    }
70 
71     ///@notice  Distirbutes a differen quantity of tokens to all the specified addresses.
72     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammounts
73     ///@param index  The airdrop to distribute based in the the array in which is saved
74     ///@param _addrs The set of addresses in array form, to which the airdrop will be distributed
75     ///@param _vals  The set of values to be distributed to each address in array form
76     function distributeAirdrop(
77         uint index,
78         address[] _addrs,
79         uint[] _vals
80     )
81         public
82         onlyOwner
83     {
84         Airdrop memory airdrop = airdrops[index];
85         if(airdrop.countDown <=now) {
86             for(uint i = 0; i < _addrs.length; ++i) {
87                 airdrop.tokenSC.transfer(_addrs[i], _vals[i]);
88             }
89         } else revert("Distribution Failed: Count Down not gone yet");
90     }
91 
92 
93   // Refound tokens back to the to airdrop creator
94     function refoundTokens(
95         uint index
96 
97     )
98         public
99         onlyOwner
100     {
101 
102         Airdrop memory airdrop = airdrops[index];
103         airdrop.tokenSC.transfer(airdrop.distributor,airdrop.tokenAmount);
104     }
105 
106     function transferGasFee(uint index) public onlyOwner {
107            Airdrop memory airdrop = airdrops[index];
108            owner.transfer(airdrop.gasFeePaid);
109        }
110 }