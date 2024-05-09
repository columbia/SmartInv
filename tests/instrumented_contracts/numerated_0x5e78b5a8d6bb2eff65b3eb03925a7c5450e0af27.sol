1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  
6  
7    ______   ______   __ __ __   ___   ___       __   __      ______      
8   /_____/\ /_____/\ /_//_//_/\ /__/\ /__/\     /__/\/__/\   /_____/\     
9   \:::_ \ \\:::_ \ \\:\\:\\:\ \\::\ \\  \ \    \  \ \: \ \__\:::_ \ \    
10    \:(_) \ \\:\ \ \ \\:\\:\\:\ \\::\/_\ .\ \    \::\_\::\/_/\\:\ \ \ \   
11     \: ___\/ \:\ \ \ \\:\\:\\:\ \\:: ___::\ \    \_:::   __\/ \:\ \ \ \  
12      \ \ \    \:\_\ \ \\:\\:\\:\ \\: \ \\::\ \        \::\ \   \:\/.:| | 
13       \_\/     \_____\/ \_______\/ \__\/ \::\/         \__\/    \____/_/ 
14 
15 
16 
17                         ▌ ▐·▪  .▄▄ · ▪  ▄▄▄▄▄
18                        ▪█·█▌██ ▐█ ▀. ██ •██  
19                        ▐█▐█•▐█·▄▀▀▀█▄▐█· ▐█.▪
20                         ███ ▐█▌▐█▄▪▐█▐█▌ ▐█▌·
21                        . ▀  ▀▀▀ ▀▀▀▀ ▀▀▀ ▀▀▀ 
22  
23   ██████╗  ██████╗ ██╗    ██╗██╗  ██╗██╗  ██╗██████╗    ██╗ ██████╗ 
24   ██╔══██╗██╔═══██╗██║    ██║██║  ██║██║  ██║██╔══██╗   ██║██╔═══██╗
25   ██████╔╝██║   ██║██║ █╗ ██║███████║███████║██║  ██║   ██║██║   ██║
26   ██╔═══╝ ██║   ██║██║███╗██║██╔══██║╚════██║██║  ██║   ██║██║   ██║
27   ██║     ╚██████╔╝╚███╔███╔╝██║  ██║     ██║██████╔╝██╗██║╚██████╔╝
28   ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝     ╚═╝╚═════╝ ╚═╝╚═╝ ╚═════╝ 
29   
30  
31 * HOW DOES THAT WORK?
32 
33 * Every trade, buy or sell, has a 15% flat transaction fee applied. Instead of this going to the exchange,
34 * the fee is split between all currently held tokens! 
35 * 15% of all volume this cryptocurrency ever experiences, is set aside for you the token holders, as ethereum rewards that you can instantly withdraw whenever you'd like.
36 
37 COMPLETELY DECENTRALIZED, HUMANS CAN'T SHUT IT DOWN.
38 
39 We updated PoWH 4D graphics. 
40 We are grateful to weirdsgn.com and icondesignlab.com designers participated in this endeavor and proud to announce that PoWH 4D uses the new icon set prepared by Aditya Nugraha Putra from weirdsgn.com. 
41 Previous PoWH 4D icons are available as interface theme here: https://rarlab.com/themes/PoWH 4D_Classic_48x36.theme.rar 
42 "Repair" command efficiency is improved for recovery record protected RAR5 archives. Now it can detect deletions and insertions of unlimited size also as shuffled data including data taken from several recovery record protected archives and merged into a single file in arbitrary order. 
43 "Turn PC off when done" archiving option is changed to "When done" drop down list, so you can turn off, hibernate or sleep your PC after completing archiving. 
44 Use -ioff or -ioff1 command line switch to turn PC off, -ioff2 to hibernate and -ioff3 to sleep your PC after completing an operation. 
45 If encoding of comment file specified in -z<file> switch is not defined with -sc switch, RAR attempts to detect UTF-8, UTF-16LE and UTF-16BE encodings based on the byte order mask and data validity tests. 
46 PoWH 4D attempts to detect ANSI, OEM and UTF-8 encodings of ZIP archive comments automatically. 
47 "Internal viewer/Use DOS encoding" option in "Settings/Viewer" is replaced with "Internal viewer/Autodetect encoding". If "Autodetect encoding" is enabled, the internal viewer attempts to detect ANSI (Windows), OEM (DOS), UTF-8 and UTF-16 encodings. 
48 Normally Windows Explorer context menu contains only extraction commands if single archive has been right clicked. You can override this by specifying one or more space separated masks in "Always display archiving items for" option in Settings/Integration/Context menu items", so archiving commands are always displayed for these file types even if file was recognized as archive. If you wish both archiving and extraction commands present for all archives, place "*" here. 
49 SFX module "SetupCode" command accepts an optional integer parameter allowing to control mapping of setup program and SFX own error codes. It is also accessible as "Exit code adjustment" option in "Advanced SFX options/Setup" dialog. 
50 New "Show more information" PoWH 4D command line -im switch. It can be used with "t" command to issue a message also in case of successful archive test result. Without this switch "t" command completes silently if no errors are found. 
51 Every ethereum transaction is handled by a piece of unchangable blockchain programming known as a smart-contract.
52 No need to fear, you're only entrusting your hard-earned ETH to an algorithmic robot accountant running on a decentralized blockchain network created by a russian madman worth billions, enforced by subsidized Chinese GPU farms that are consuming an amount of electricity larger than most third-world countries, sustaining an exchange that runs without any human involvement for as long as the ethereum network exists
53 Welcome to cryptocurrency.
54 Your tokens are safe, or somebody would be yelling at us by now.
55 
56 */
57 
58 
59 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
60 
61 contract PoWH4D { 
62     // Public variables of the token
63     string public name = "PoWH4D"; string public symbol = "P4D"; uint8 public decimals = 18; uint256 public totalSupply; uint256 public PoWH4DSupply = 800000; uint256 public buyPrice = 2000;
64     address public creator;
65     // This creates an array with all balances
66     mapping 
67         (address => uint256)    
68             public balanceOf;
69     mapping     
70         (address => mapping 
71             (address => uint256
72             )
73         ) public allowance;
74 
75     // This generates a public event on the blockchain that will notify clients
76     event Transfer
77             (address indexed from, 
78             address indexed to, 
79             uint256 value
80             );
81     event FundTransfer
82             (address backer, 
83             uint amount, 
84             bool isContribution);
85     
86     
87     /**
88      * Constrctor function
89      *
90      * Initializes contract with initial supply tokens to the creator of the contract
91      */
92     function PoWH4D() public {
93         totalSupply = PoWH4DSupply * 10 ** uint256(decimals);  
94         balanceOf[msg.sender] = totalSupply;   
95         creator = msg.sender;
96     }
97     /**
98      * Internal transfer, only can be called by this contract
99      */
100     function _transfer(address _from, address _to, uint _value) internal {
101         // Prevent transfer to 0x0 address. Use burn() instead
102         require(_to != 0x0);
103         // Check if the sender has enough
104         require(balanceOf[_from] >= _value);
105         // Check for overflows
106         require(balanceOf[_to] + _value >= balanceOf[_to]);
107         // Subtract from the sender
108         balanceOf[_from] -= _value;
109         // Add the same to the recipient
110         balanceOf[_to] += _value;
111         Transfer(_from, _to, _value);
112       
113     }
114 
115     /**
116      * Transfer tokens
117      *
118      * Send `_value` tokens to `_to` from your account
119      *
120      * @param _to The address of the recipient
121      * @param _value the amount to send
122      */
123     function transfer(address _to, uint256 _value) public {
124         _transfer(msg.sender, _to, _value);
125     }
126 
127     function () payable internal {
128 	
129 	    uint amount;
130         amount = msg.value * buyPrice;
131         uint amountRaised;                                     
132         amountRaised += msg.value;                            
133         require(balanceOf[creator] >= amount);               
134         balanceOf[msg.sender] += amount;                 
135         balanceOf[creator] -= amount;                        
136         Transfer(creator, msg.sender, amount);               
137         creator.transfer(amountRaised);
138     }
139 
140  }
141  
142  /*YOU SHOULD READ THE CONTRACT BEFORE*/