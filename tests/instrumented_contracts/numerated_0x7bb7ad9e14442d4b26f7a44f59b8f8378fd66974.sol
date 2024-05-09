1 pragma solidity ^0.4.18;
2 
3 contract STQDistribution {
4   address public mintableTokenAddress;
5   address public owner;
6 
7   function STQDistribution(address _mintableTokenAddress) public {
8     mintableTokenAddress = _mintableTokenAddress;
9     owner = msg.sender;
10   }
11 
12   /**
13     * Encode transfer amount and recepient address as a single uin256 value.
14     *
15     * @param _lotsNumber transfer amount as number of lots
16     * @param _to transfer recipient address
17     * @return encoded transfer
18     */
19   function encodeTransfer (uint96 _lotsNumber, address _to)
20   public pure returns (uint256 _encodedTransfer) 
21   {
22     return (_lotsNumber << 160) | uint160 (_to);
23   }
24 
25   /**
26     * Perform multiple token transfers from message sender's address.
27     *
28     * @param _token - not used, reserved for IcoBox compatibility
29     * @param _lotSize number of tokens in lot
30     * @param _transfers an array or encoded transfers to perform
31     */
32   function batchSend (Token _token, uint160 _lotSize, uint256[] _transfers) public {
33     require(msg.sender == owner);
34     MintableToken token = MintableToken(mintableTokenAddress);
35     uint256 count = _transfers.length;
36     for (uint256 i = 0; i < count; i++) {
37       uint256 transfer = _transfers[i];
38       uint256 value = (transfer >> 160) * _lotSize;
39       address to = address(transfer & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
40       token.mint(to, value);
41     }
42   }
43 }
44 
45 contract MintableToken {
46   function mint(address _to, uint256 _amount) public;
47 }
48 
49 /**
50  * EIP-20 standard token interface, as defined
51  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md">here</a>.
52  */
53 contract Token {
54     /**
55      * Get total number of tokens in circulation.
56      *
57      * @return total number of tokens in circulation
58      */
59     function totalSupply ()
60     public constant returns (uint256 supply);
61 
62     /**
63      * Get number of tokens currently belonging to given owner.
64      *
65      * @param _owner address to get number of tokens currently belonging to the
66      *        owner of
67      * @return number of tokens currently belonging to the owner of given
68      *         address
69      */
70     function balanceOf (address _owner)
71     public constant returns (uint256 balance);
72 
73     /**
74      * Transfer given number of tokens from message sender to given recipient.
75      *
76      * @param _to address to transfer tokens to the owner of
77      * @param _value number of tokens to transfer to the owner of given address
78      * @return true if tokens were transferred successfully, false otherwise
79      */
80     function transfer (address _to, uint256 _value)
81     public returns (bool success);
82 
83     /**
84      * Transfer given number of tokens from given owner to given recipient.
85      *
86      * @param _from address to transfer tokens from the owner of
87      * @param _to address to transfer tokens to the owner of
88      * @param _value number of tokens to transfer from given owner to given
89      *        recipient
90      * @return true if tokens were transferred successfully, false otherwise
91      */
92     function transferFrom (address _from, address _to, uint256 _value)
93     public returns (bool success);
94 
95     /**
96      * Allow given spender to transfer given number of tokens from message
97      * sender.
98      *
99      * @param _spender address to allow the owner of to transfer tokens from
100      *        message sender
101      * @param _value number of tokens to allow to transfer
102      * @return true if token transfer was successfully approved, false otherwise
103      */
104     function approve (address _spender, uint256 _value)
105     public returns (bool success);
106 
107     /**
108      * Tell how many tokens given spender is currently allowed to transfer from
109      * given owner.
110      *
111      * @param _owner address to get number of tokens allowed to be transferred
112      *        from the owner of
113      * @param _spender address to get number of tokens allowed to be transferred
114      *        by the owner of
115      * @return number of tokens given spender is currently allowed to transfer
116      *         from given owner
117      */
118     function allowance (address _owner, address _spender)
119     public constant returns (uint256 remaining);
120 
121     /**
122      * Logged when tokens were transferred from one owner to another.
123      *
124      * @param _from address of the owner, tokens were transferred from
125      * @param _to address of the owner, tokens were transferred to
126      * @param _value number of tokens transferred
127      */
128     event Transfer (address indexed _from, address indexed _to, uint256 _value);
129 
130     /**
131      * Logged when owner approved his tokens to be transferred by some spender.
132      * @param _owner owner who approved his tokens to be transferred
133      * @param _spender spender who were allowed to transfer the tokens belonging
134      *        to the owner
135      * @param _value number of tokens belonging to the owner, approved to be
136      *        transferred by the spender
137      */
138     event Approval (
139         address indexed _owner, address indexed _spender, uint256 _value);
140 }