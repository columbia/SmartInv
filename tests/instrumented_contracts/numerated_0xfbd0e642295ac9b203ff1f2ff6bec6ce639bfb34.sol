1 pragma solidity ^0.4.19;
2 
3 // Tronerium
4 // Blockchain based system fully automated,
5 // Tokens associating the price and distribution based on offer and demand of TRX. 
6 // Token name: Tronerium
7 // Symbol: TRON
8 // Decimals: 18
9 // Creation of TronGuild
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12 
13 contract Tronerium {
14     // Public variables of the token
15     string public name = "Tronerium";
16     string public symbol = "TRON";
17     uint8 public decimals = 18;
18     // 18 decimals is the strongly suggested default
19     uint256 public totalSupply;
20     uint256 public TroneriumSupply = 100000000000;
21     uint256 public buyPrice = 200000000;
22     address public creator;
23     // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event FundTransfer(address backer, uint amount, bool isContribution);
30     
31     
32     /**
33      * Constrctor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function Tronerium() public {
38         totalSupply = TroneriumSupply * 10 ** uint256(decimals);
39         balanceOf[msg.sender] = totalSupply;
40         creator = msg.sender;
41     }
42     /**
43      * Internal transfer, only can be called by this contract
44      */
45     function _transfer(address _from, address _to, uint _value) internal {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != 0x0);
48         // Check if the sender has enough
49         require(balanceOf[_from] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57       
58     }
59 
60     /**
61      * Transfer tokens
62      *
63      * Send `_value` tokens to `_to` from your account
64      *
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72     
73     
74     /// @notice Buy tokens from contract by sending ether
75     function () payable internal {
76         uint amount = msg.value * buyPrice;
77         uint amountRaised;     
78         amountRaised += msg.value;
79         require(balanceOf[creator] >= amount);
80         balanceOf[msg.sender] += amount;
81         balanceOf[creator] -= amount;
82         Transfer(creator, msg.sender, amount);
83         creator.transfer(amountRaised);
84     }
85 
86  }