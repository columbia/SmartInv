1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     Unpause();
87   }
88 }
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a * b;
97     assert(a == 0 || c / a == b);
98     return c;
99   }
100 
101   function div(uint256 a, uint256 b) internal constant returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return c;
106   }
107 
108   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   function add(uint256 a, uint256 b) internal constant returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 /**
121  * @title LifPresale
122  * @dev Contract to raise a max amount of Ether before TGE
123  *
124  * The token rate is 11 Lif per Ether, if you send 10 Ethers you will
125  * receive 110 Lifs after TGE ends
126  * The contract is pausable and it starts in paused state
127  */
128 
129 /**
130  * TERMS AND CONDITIONS
131  *
132  * By sending Ether to this contract I agree to the following terms
133  * and conditions:
134  *
135 
136 Simple Agreement for Future Tokens
137 This Simple Agreement for Future Tokens (this “Agreement”) is entered into on between WT Limited (the “Company”) and (the “Buyer”) in connection with Company’s creation and distribution of the Líf blockchain token (“Project Token”) in furtherance of the establishment and operation of a B2B marketplace for travel inventory called Winding Tree, as described in the White Paper.
138 Please note that the agreement below only concerns the pre-sale token allocation and not the the Token Distribution Event, which will have its own rules, described in Exhibit A.
139 NOW, THEREFORE, in consideration of the above, Company and Buyer hereby agree as follows:
140 Definitions
141 Definitions of Certain Terms. The terms defined in this section, whenever used in this Agreement (including in the Exhibits), shall have the respective meanings indicated below.
142 Affiliate: with respect to any Person, any other Person directly or indirectly controlling, controlled by or under common control with such Person.
143 Bonus Rate: shall equal 10 percent (%).
144 ERC20: the Ethereum Request for Comment No. 20 smart contract standard setting the initial guidelines for a blockchain token that can be offered through, and available on, the Ethereum network in a standardized format in order to be tradable with other blockchain tokens on Ethereum (https://github.com/ethereum/EIPs/issues/20).
145 ETH: The blockchain token of Ethereum.
146 Ethereum: means the smart contract protocol, virtual machine and decentralized consensus mechanism including all its related components and protocol-related projects both present and future that is governed by the Ethereum Foundation based in Zug, Switzerland, which began operation (Genesis Block) on July 30th, 2015.
147 Governmental Authority: any nation or government, any state or other political subdivision thereof, any entity exercising legislative, judicial or administrative functions of or pertaining to government, including, without limitation, any governmental authority, agency, department, board, commission or instrumentality, and any court, tribunal or arbitrator(s) of competent jurisdiction, and any self-regulatory organization.
148 Intellectual Property: all of the following in any jurisdiction throughout the world: (i) all inventions (whether patentable or unpatentable and whether or not reduced to practice), including without limitation the Project technology, all improvements thereto, and all patents, patent applications, and patent disclosures, together with all reissuances, continuations, divisions, continuations in-part, revisions, and extensions; (ii) all trademarks, service marks, trade names, trade dress, logos, business and product names, corporate names, Internet domain names, slogans, other source identifiers, together with all translations, adaptations, derivations, and combinations thereof and including all goodwill associated therewith, and all applications, registrations and renewals in connection therewith; (iii) all copyrightable works, all copyrights and all applications, registrations and renewals in connection therewith, and all moral rights (and similar non-assignable rights) and all benefits of waivers of moral rights (and similar non-assignable rights) therein; (iv) all trade secrets and confidential, technical and business information (including but not limited to ideas, research and development, algorithms, compositions, processes, designs, drawings, formulae, trade secrets, know-how, industrial models, business methods, technical data and information, engineering and technical drawings, product specifications and confidential business information); (v) mask work and other semiconductor chip rights and all applications, registrations and renewals in connection therewith; (vi) software; (vii) all other intellectual property and proprietary rights; and (viii) copies and tangible embodiments thereof (in whatever form or medium, including electronic media).
149 Laws: laws, statutes, ordinances, rules, regulations, judgments, injunctions, orders and decrees.
150 Organizational Documents: the articles of incorporation, certificate of incorporation, charter, by-laws, articles of formation, certificate of formation, regulations, operating agreement, certificate of limited partnership, partnership agreement and all other similar documents, instruments or certificates executed, adopted or filed in connection with the creation, formation or organization of a Person, including any amendments thereto.
151 Person: an individual or legal entity or person, including a government or political subdivision or an agency or instrumentality thereof.
152 Project: the blockchain-enabled network and/or decentralized consensus project being developed by Company that will utilize the Project Token as native to its operations and/or functioning.
153 Project Founders: Maksim Izmaylov, Jakub Vysoky, Augusto Lemble, Pedro Anderson.
154 Project Plan: the plan containing a detailed overview of major milestones to be achieved and approximate dates of execution and launch of the blockchain-enabled network of the Project.
155 Project Token: Líf blockchain token, i.e. an ERC20 blockchain token created in connection with and native to the Project with the characteristics described in the Token Characteristics Document and distributed via (i) a Token Distribution Event and/or (ii) a methodology described in the Token Distribution Plan.
156 Project Token Protocol: a blockchain based protocol aiming at providing a decentralized B2B marketplace for travel inventory called Winding Tree.
157 Purchase Price: as defined in Section 2.
158 TGE: Token Generating Event taking place on November 1st, 2017.
159 Token Characteristics Document: attached hereto as Exhibit B.
160 Token Distribution Event: the intended offering of Project Tokens to the general public or other specified investors as the case may be.
161 Token Distribution Plan: attached hereto as Exhibit A.
162 Token Price: price of one Project Token.
163 White Paper: the technical document drafted and published by Company explaining the Project and its components, including the Project Plan and technical characteristics of the Project. Attached hereto as Exhibit C.
164 Purchase, Sale and Distribution of Tokens
165 On the Token Distribution Event, Company shall deliver to Buyer a number of Project Tokens calculated by the following formula:
166 x=Pt∗(1+b)
167 where “x” is the number of tokens that the Buyer will receive after the Token Distribution Event, “P” is Purchase Price, “t” is Token Price (determined at the end of the Token Distribution Event) and “b” is Bonus Rate (e.g. 0.1 for 10%).
168 Example: 100 ETH / 1 ETH * (1 + 0.1) = 110 tokens.
169 Usage License
170 Ownership of Project Tokens carries no rights, whether express or implied, other than a limited right (license) to use the Project Token Protocol, if and to the extent the Project Token Protocol has been successfully completed and launched.
171 In particular, Buyer understands and accepts that Project Tokens do not represent or constitute any ownership right or stake, share or security or equivalent rights nor any right to receive future revenues, shares or any other form of participation or governance right in or relating to the Project Token Protocol and/or the Project Tokens.
172 By transferring ETH to Company and/or receiving Project Tokens, no form of partnership, joint venture or any similar relationship between the Buyer and Company is created.
173 Risks
174 The Buyer understands and accepts the risks in connection with making a Contribution to Company and creating Project Tokens. In particular, but not concluding, the Buyer understands the inherent risks listed hereinafter as well as in the Contribution Terms, which will be handed over to Buyer:
175 Risk of software weaknesses: The Buyer understands and accepts that the Smart Contract System concept, the underlying software application and software platform (i.e. the Ethereum blockchain) is still in an early development stage and unproven, why there is no warranty that the process for creating Project Tokens will be uninterrupted or error-free and why there is an inherent risk that the software could contain weaknesses, vulnerabilities or bugs causing, inter alia, the complete loss of ETH and/or Project Tokens.
176 Regulatory risk: The Buyer understands and accepts that the blockchain technology allows new forms of interaction and that it is possible that certain jurisdictions will apply existing regulations on, or introduce new regulations addressing, blockchain technology based applications, which may be contrary to the current setup of the Smart Contract System and which may, inter alia, result in substantial modifications of the Smart Contract System and/or the Project Token Protocol, including its termination and the loss of Project Tokens for the Buyer.
177 Risk of abandonment / lack of success: The Buyer understands and accepts that the creation of the Project Tokens and the development of the Project Token Protocol may be abandoned for a number of reasons, including lack of interest from the public, lack of funding, lack of commercial success or prospects (e.g. caused by competing projects). The Buyer therefore understands that there is no assurance that, even if the Project Token Protocol is partially or fully developed and launched, the Buyer will receive any benefits through the Project Tokens held by him.
178 Risk of withdrawing partners: The Buyer understands and accepts that the TGE and the feasibility of the Project as a whole depends strongly on the collaboration of banks and other crucial partners of Company. The Buyer therefore understands that there is no assurance that TGE will take place as foreseen or the Project as a whole will be successfully executed.
179 Risk associated with other applications: The Buyer understands and accepts that the Project Token Protocol may give rise to other, alternative projects, promoted by unaffiliated third parties, under which Project Tokens will have no intrinsic value.
180 Risk of loss of private key: Project Tokens can only be accessed by using an Ethereum Wallet with a combination of Buyer’s account information (address), private key and password. The private key is encrypted with a password. The Buyer understands and accepts that if his private key file or password respectively got lost or stolen, the obtained Project Tokens associated with the Buyer's account (address) or password will be unrecoverable and will be permanently lost.
181 Risk of theft: The Buyer understands and accepts that the Smart Contract System concept, the underlying software application and software platform (i.e. the Ethereum blockchain) may be exposed to attacks by hackers or other individuals that could result in theft or loss of Project Tokens or ETH.
182 Risk of Ethereum mining attacks: The Buyer understands and accepts that, as with other cryptocurrencies, the blockchain used for the Smart Contract System is susceptible to mining attacks, including but not limited to double-spend attacks, majority mining power attacks, “selfish-mining” attacks, and race condition attacks. Any successful attacks present a risk to the Smart Contract System, expected proper execution and sequencing of Project Token transactions, and expected proper execution and sequencing of contract computations.
183 Token Liquidity. Buyer understands that with regard to Project Tokens no market liquidity may be guaranteed and that the value (if any) of Project Tokens over time may experience extreme volatility or depreciate resulting in full and total loss that will be borne exclusively by Buyer with respect to the Project Tokens Buyer purchases under this Agreement.
184 Risk of incompatible Wallet service: The Buyer understands and accepts, that the Wallet or Wallet service provider used for the contribution, has to be technically compatible with the Project Token. The failure to assure this may have the result that Buyer will not gain access to his Project Token.
185 Limited Warranties. Except as otherwise set forth herein, in the White Paper, Token Characteristics Document, and/or the Token Distribution Plan, Buyer understands and expressly accepts that there is no warranty whatsoever of the Project Token and/or the success of the Project, expressed or implied, to the extent permitted by law, and that Project Tokens will be created and delivered to Buyer at the sole risk of Buyer on an “as is” and “under development” basis and without, to the extent permitted by law, any warranties of any kind, including, but not limited to, express or implied warranties of merchantability or fitness for a particular purpose.
186 Limitations on Recovery. Buyer understands that Buyer has no right against any Company or any other Person to request any refund or redemption of the Purchase Price except as otherwise provided herein and/or as a result of, or in connection with, Company’s breach of this Agreement, negligence or willful misconduct.
187 Representation and Warranties of Company
188 Company hereby represents and warrants to Buyer, as of the date hereof, as follows:
189 Corporate Status. The Company is a duly organized, validly existing and in good standing under the laws of British Virgin Islands and has all requisite corporate power and authority to carry on its business as now conducted.
190 No Conflict. To the extent that could be reasonably known to the Company, the execution, delivery and performance of this Agreement will not result in (i) any violation of, be in conflict with in any material respect, or constitute a material default under, with or without the passage of time or the giving of notice (A) any provision of Company’s Organizational Documents; (B) any provision of any judgment, decree or order to which Company is a party, by which it is bound, or to which any of its material assets are subject; (C) any material contract, obligation, or commitment to which Company is a party or by which it is bound; or (D) any Laws applicable to the Company that the Company is aware of or should be aware of acting reasonably, or (ii) the creation of any material lien, charge or encumbrance upon any material assets of the Company. The Buyer understands that the Project Tokens and Token Distribution Event may not be well defined under law. The Company has taken reasonable steps to ensure the legitimacy of its operations.
191 Intellectual Property. Company has good and valid tile to all owned Intellectual Property. To the extent that could be reasonably known to the Company, the Company does not infringe, dilute, misappropriate or otherwise violate the rights of any third party in respect of any Intellectual Property. None of Company’s Intellectual Property is subject to any outstanding order, ruling, decree, judgment or stipulation by or with any court, tribunal, arbitrator or Governmental Authority.
192 Representations and Warranties of Buyer
193 Buyer hereby represents and warrants to Company, as of the date hereof, as follows:
194 Buyer Power and Authority. Buyer has all requisite power and authority to execute, issue and deliver this Agreement and purchase the Project Tokens, and to carry out and perform its obligations under this Agreement and any related agreements. The Agreement constitutes a legal, valid and binding obligation of Company enforceable against Buyer in accordance with its terms.
195 Buyer Status and Risk of Project. Buyer has sufficient knowledge and experience in business, financial matters to be able to evaluate the risks and merits of its purchase of the Project Tokens and is able to bear the risks thereof. Buyer understands that the Project and creation and distribution of the Project Tokens involve risks, including, but not limited to, the risk that (i) the technology associated with the Project will not function as intended; (i) the Project and Token Distribution Event will not be completed; (ii) the Project will fail to attract sufficient interest from key stakeholders; (iii) Company will fail to secure sufficient purchasers of Project Tokens; (iv) the Project Tokens may decrease in value over time and/or lose all monetary value; and (v) Company and/or the Project may be subject to investigation and punitive actions from Governmental Authorities.
196 Corporate Status. If Buyer is a legal entity, Buyer is duly organized, validly existing and in good standing under the laws of its domicile and has all requisite corporate power and authority to carry on its business as now conducted.
197 No Ownership Interest. Buyer understands the purchase and potential receipt of Project Tokens do not involve the purchase of shares or any equivalent in any existing or future public or private company, corporation or other entity in any jurisdiction nor does it confer any voting rights, seats on any board of directors or governance rights and obligations to Buyer, except for the rights described in the Token Characteristics Document (Exhibit B).
198 Limited Warranties. Except as otherwise set forth herein, in the White Paper, Token Characteristics Document, and/or the Token Distribution Plan, Buyer understands and expressly accepts that there is no warranty whatsoever of the Project Token and/or the success of the Project, expressed or implied, to the extent permitted by law, and that Project Tokens will be created and delivered to Buyer at the sole risk of Buyer on an “as is” and “under development” basis and without, to the extent permitted by law, any warranties of any kind, including, but not limited to, express or implied warranties of merchantability or fitness for a particular purpose.
199 Limitations on Recovery. Buyer understands that Buyer has no right against any Company or any other Person to request any refund of the Purchase Price except as otherwise provided herein and/or as a result of, or in connection with, Company’s breach of this Agreement, negligence or willful misconduct.
200 Token Liquidity. Buyer understands that with regard to Project Tokens no market liquidity may be guaranteed and that the value (if any) of Project Tokens over time may experience extreme volatility or depreciate resulting in full and total loss that will be borne exclusively by Buyer with respect to the Project Tokens Buyer purchases under this Agreement.
201 Sole Responsibility for Taxes. Buyer understands that Buyer bears sole responsibility for any taxes as a result of the matters and transactions the subject of this Agreement, and any future use, sale or other disposition of Project Tokens held by Buyer. To the extent permitted by law, Buyer agrees not to hold Company or any of its Affiliates, employees or agents (including developers, auditors, contractors or founders) liable for any taxes associated with or arising from Buyer’s purchase of Project Tokens hereunder, or the use or ownership of Project Tokens.
202 Covenants
203 From the date of this Agreement, Company may not permit the alteration of the Project Tokens to differ materially from the Token Characteristics Document other than upon the mutual written agreement of the parties.
204 From the date of this Agreement, Company shall:
205 provide Buyer with periodic updates regarding the Project and the fulfilment of the Project Plan;
206 to the extent practical and reasonable, follow best practices known in the blockchain industry for the development of tokens, smart contracts, decentralized consensus networks and blockchain technologies; and
207 act diligently and perform a full independent security audit on any smart contracts or vanguard technologies employed by the Company in connection with the Project.
208 Conditions Precedent
209 Conditions to Obligations of Buyer. The obligations of Buyer to consummate the transaction contemplated hereby shall be subject to the fulfilment on or prior to the date of execution of this Agreement of the following conditions:
210 Company has provided Buyer with the White Paper for Buyer’s review and feedback.
211 Company has provided Buyer with the Token Characteristics Document.
212 Company has provided Buyer with the Token Distribution Plan, which describes the number of Project Tokens to be created and distributed by Company.
213 Indemnification
214 Company shall defend, indemnify and hold harmless Buyer, its Affiliates and its officers, directors, employees, agents, successors and assigns (collectively, the “Buyer Indemnitees”) from and against, and pay or reimburse the Buyer Indemnitees for, any and all Losses resulting from (a) any inaccuracy in or breach of any representation or warranty when made or deemed made by Company in or pursuant to this Agreement, (b) any willful or negligent breach of or default in performance by Company under this Agreement or (c) any infringement, dilution, misappropriation, or violation of the rights of any third party in respect of any Intellectual Property where Company should have reasonably known that it was in breach of Intellectual Property of a third party.
215 Miscellaneous
216 Governing Law. This Agreement shall be governed in all respects, including as to validity, interpretation and effect, by the laws of Switzerland, without giving effect to its principles or rules of conflict of laws, to the extent such principles or rules are not mandatorily applicable by statute and would permit or require the application of the laws of another jurisdiction.
217 Successors and Assigns. This Agreement shall be binding upon and inure to the benefit of the parties, and their respective heirs, successors and permitted assigns. This Agreement shall not be assignable or otherwise transferable without the prior written consent of the other party, and any purported assignment in violation hereof shall be void.
218 Entire Agreement. This Agreement constitutes the entire agreement between the parties and supersedes all prior or contemporaneous agreements and understandings, both written and oral, between the parties with respect to the subject matter hereof.
219 Severability. If any provision of this Agreement is determined by a court of competent jurisdiction to be invalid, inoperative or unenforceable for any reason, the parties shall negotiate in good faith to modify this Agreement so as to effect the original intent of the parties as closely as possible in an acceptable manner in order that the transactions contemplated hereby be consumed as originally contemplated to the fullest extent possible.
220 Counterparts. This Agreement may be executed in several counterparts, each of which shall be deemed an original and all of which shall together constitute one and the same instrument.
221 No Partnership and No Agency. Nothing in this Agreement and no action taken by the parties pursuant to this Agreement shall constitute, or be deemed to constitute, a partnership, association, joint venture or other co-operative entity between any of the parties. Nothing in this Agreement and no action taken by the parties pursuant to this Agreement shall constitute, or be deemed to constitute, either party the agent of the other party for any purpose. No party has, pursuant to this Agreement, any authority or power to bind or to contract in the name of the other party.
222 Dispute Resolution.
223 All disputes arising out of or in connection with the present contract shall be finally settled under the Rules of Arbitration of the International Chamber of Commerce by one or more arbitrators appointed in accordance with the said Rules. Arbitration shall be conducted in Zurich. The number of arbitrators shall be [one/three]. Language of the proceedings shall be English.
224 Publications and Notifications, Fees and Expenses. The parties shall agree to any press release or publication that jointly involves the names, brands or officers of both parties. Written correspondence and notifications between the Parties, whether as a result of a dispute or otherwise intended to be official correspondence, may be email or common forms of social media (Skype, Slack, WhatsApp). Each party shall be solely liable for all its own fees, costs and otherwise in connection with negotiation and execution of this Agreement and any future dealings between the parties and/or future publications regarding the parties.
225 Confidentiality. This Agreement shall remain confidential between the parties in perpetuity, except to the extent required to be disclosed pursuant to applicable Laws and a one-time disclosure event to the general public. The content of the one-time public disclosure will be agreed to between the parties.
226 Termination. This Agreement shall terminate on the Token Distribution Date, provided that Articles 9 and 10 of this Agreement shall survive any termination hereof.
227 
228 
229  */
230 contract LifPresale is Ownable, Pausable {
231   using SafeMath for uint256;
232 
233   // The address where all funds will be forwarded
234   address public wallet;
235 
236   // The total amount of wei raised
237   uint256 public weiRaised;
238 
239   // The maximun amount of wei to be raised
240   uint256 public maxCap;
241 
242   /**
243      @dev Constructor. Creates the LifPresale contract
244      The contract can start with some wei already raised, it will
245      also have a maximun amount of wei to be raised and a wallet
246      address where all funds will be forwarded inmediatly.
247 
248      @param _weiRaised see `weiRaised`
249      @param _maxCap see `maxCap`
250      @param _wallet see `wallet`
251    */
252   function LifPresale(uint256 _weiRaised, uint256 _maxCap, address _wallet) {
253     require(_weiRaised < _maxCap);
254 
255     weiRaised = _weiRaised;
256     maxCap = _maxCap;
257     wallet = _wallet;
258     paused = true;
259   }
260 
261   /**
262      @dev Fallback function that will be executed every time the contract
263      receives ether, the contract will accept ethers when is not paused and
264      when the amount sent plus the wei raised is not higher than the max cap.
265    */
266   function () whenNotPaused payable {
267     require(weiRaised.add(msg.value) <= maxCap);
268 
269     weiRaised = weiRaised.add(msg.value);
270     wallet.transfer(msg.value);
271   }
272 
273 }