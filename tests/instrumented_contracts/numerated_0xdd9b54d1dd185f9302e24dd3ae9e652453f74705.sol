1 //! FeeRegistrar contract.
2 //! By Parity Technologies, 2017.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.16;
6 
7 // From Owned.sol
8 contract Owned {
9   /// STORAGE
10   address public owner = msg.sender;
11 
12   /// EVENTS
13   event NewOwner(address indexed old, address indexed current);
14 
15   /// MODIFIERS
16   modifier only_owner { require (msg.sender == owner); _; }
17 
18   /// RESTRICTED PUBLIC METHODS
19   function setOwner(address _new) public only_owner { NewOwner(owner, _new); owner = _new; }
20 }
21 
22 /// @title Delegated Contract
23 /// @notice This contract can be used to have a a system of delegates
24 /// who can be authorized to execute certain methods. A (super-)owner
25 /// is set, who can modify the delegates.
26 contract Delegated is Owned {
27   /// STORAGE
28   mapping (address => bool) delegates;
29 
30   /// MODIFIERS
31   modifier only_delegate { require (msg.sender == owner || delegates[msg.sender]); _; }
32 
33   /// PUBLIC METHODS
34   function delegate(address who) public constant returns (bool) { return who == owner || delegates[who]; }
35 
36   /// RESTRICTED PUBLIC METHODS
37   function addDelegate(address _new) public only_owner { delegates[_new] = true; }
38   function removeDelegate(address _old) public only_owner { delete delegates[_old]; }
39 }
40 
41 /// @title Fee Registrar
42 /// @author Nicolas Gotchac <nicolas@parity.io>
43 /// @notice This contract records fee payments. The address who deploys the contract
44 /// is set as the `owner` of the contract (which can be later modified). The `fee`
45 /// which users will have to pay must be specified, as well as the address of the treasury
46 /// to which the fee will be forwarded to.
47 /// A payment is a transaction with the value set as the `fee` value, and an address is
48 /// given as an argument. The given address will be marked as _paid for_, and the number
49 /// of times it was paid for will be recorded. We also record who is at the origin of the
50 /// payment.
51 /// For example, Alice can pay for Bob, and Eve can pay for Bob as well. This contract
52 /// will record that Bob is marked as paid, 2 times, by Alice and Eve.
53 /// A payment can be revoked by specified delegates, and the fund should be restored to
54 /// the payer of the fee.
55 contract FeeRegistrar is Delegated {
56   /// STORAGE
57   address public treasury;
58   uint public fee;
59 
60   // a mapping of addresses to the origin of payments struct
61   mapping(address => address[]) s_paid;
62 
63 
64   /// EVENTS
65   event Paid (address who, address payer);
66 
67 
68   /// CONSTRUCTOR
69 
70   /// @notice Contructor method of the contract, which
71   /// will set the `treasury` where payments will be send to,
72   /// and the `fee` users have to pay
73   /// @param _treasury The address to which the payments will be forwarded
74   /// @param _fee The fee users have to pay, in wei
75   function FeeRegistrar (address _treasury, uint _fee) public {
76     owner = msg.sender;
77     treasury = _treasury;
78     fee = _fee;
79   }
80 
81 
82   /// PUBLIC CONSTANT METHODS
83 
84   /// @notice Returns for the given address the number of times
85   /// it was paid for, and an array of addresses who actually paid for the fee
86   /// (as one might pay the fee for another address)
87   /// @param who The address of the payer whose info we check
88   /// @return The count (number of payments) and the origins (the senders of the
89   /// payment)
90   function payer (address who) public constant returns (uint count, address[] origins) {
91     address[] memory m_origins = s_paid[who];
92 
93     return (m_origins.length, m_origins);
94   }
95 
96   /// @notice Returns whether the given address paid or not
97   /// @param who The address whose payment status we check
98   /// @ return Whether the address is marked as paid or not
99   function paid (address who) public constant returns (bool) {
100     return s_paid[who].length > 0;
101   }
102 
103 
104   /// PUBLIC METHODS
105 
106   /// @notice This method is used to pay for the fee. You can pay
107   /// the fee for one address (then marked as paid), from another
108   /// address. The origin of the transaction, the
109   /// fee payer (`msg.sender`) is stored in an array.
110   /// The value of the transaction must
111   /// match the fee that was set in the contructor.
112   /// The only restriction is that you can't pay for the null
113   /// address.
114   /// You also can't pay more than 10 times for the same address
115   /// The value that is received is directly transfered to the
116   /// `treasury`.
117   /// @param who The address which should be marked as paid.
118   function pay (address who) external payable {
119     // We first check that the given address is not the null address
120     require(who != 0x0);
121     // Then check that the value matches with the fee
122     require(msg.value == fee);
123     // Maximum 10 payments per address
124     require(s_paid[who].length < 10);
125 
126     s_paid[who].push(msg.sender);
127 
128     // Send the paid event
129     Paid(who, msg.sender);
130 
131     // Send the message value to the treasury
132     treasury.transfer(msg.value);
133   }
134 
135 
136   /// RESTRICTED (owner or delegate only) PUBLIC METHODS
137 
138   /// @notice This method can only be called by the contract
139   /// owner, and can be used to virtually create a new payment,
140   /// by `origin` for `who`.
141   /// @param who The address that `origin` paid for
142   /// @param origin The virtual sender of the payment
143   function inject (address who, address origin) external only_owner {
144     // Add the origin address to the list of payers
145     s_paid[who].push(origin);
146     // Emit the `Paid` event
147     Paid(who, origin);
148   }
149 
150   /// @notice This method can be called by authorized persons only,
151   /// and can issue a refund of the fee to the `origin` address who
152   /// paid the fee for `who`.
153   /// @param who The address that `origin` paid for
154   /// @param origin The sender of the payment, to which we shall
155   /// send the refund
156   function revoke (address who, address origin) payable external only_delegate {
157     // The value must match the current fee, so we can refund
158     // the payer, since the contract doesn't hold anything.
159     require(msg.value == fee);
160     bool found;
161 
162     // Go through the list of payers to find
163     // the remove the right one
164     // NB : this list is limited to 10 items,
165     //      @see the `pay` method
166     for (uint i = 0; i < s_paid[who].length; i++) {
167       if (s_paid[who][i] != origin) {
168         continue;
169       }
170 
171       // If the origin payer is found
172       found = true;
173 
174       uint last = s_paid[who].length - 1;
175 
176       // Switch the last element of the array
177       // with the one to remove
178       s_paid[who][i] = s_paid[who][last];
179 
180       // Remove the last element of the array
181       delete s_paid[who][last];
182       s_paid[who].length -= 1;
183 
184       break;
185     }
186 
187     // Ensure that the origin payer has been found
188     require(found);
189 
190     // Refund the fee to the origin payer
191     who.transfer(msg.value);
192   }
193 
194   /// @notice Change the address of the treasury, the address to which
195   /// the payments are forwarded to. Only the owner of the contract
196   /// can execute this method.
197   /// @param _treasury The new treasury address
198   function setTreasury (address _treasury) external only_owner {
199     treasury = _treasury;
200   }
201 }