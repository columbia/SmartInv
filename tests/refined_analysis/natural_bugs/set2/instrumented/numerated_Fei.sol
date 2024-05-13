1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
5 import "./IIncentive.sol";
6 import "../refs/CoreRef.sol";
7 
8 /// @title FEI stablecoin
9 /// @author Fei Protocol
10 contract Fei is IFei, ERC20Burnable, CoreRef {
11     /// @notice get associated incentive contract, 0 address if N/A
12     mapping(address => address) public override incentiveContract;
13 
14     // solhint-disable-next-line var-name-mixedcase
15     bytes32 public DOMAIN_SEPARATOR;
16     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
17     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
18     mapping(address => uint256) public nonces;
19 
20     /// @notice Fei token constructor
21     /// @param core Fei Core address to reference
22     constructor(address core) ERC20("Fei USD", "FEI") CoreRef(core) {
23         uint256 chainId;
24         // solhint-disable-next-line no-inline-assembly
25         assembly {
26             chainId := chainid()
27         }
28         DOMAIN_SEPARATOR = keccak256(
29             abi.encode(
30                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
31                 keccak256(bytes(name())),
32                 keccak256(bytes("1")),
33                 chainId,
34                 address(this)
35             )
36         );
37     }
38 
39     /// @param account the account to incentivize
40     /// @param incentive the associated incentive contract
41     function setIncentiveContract(address account, address incentive) external override onlyGovernor {
42         incentiveContract[account] = incentive;
43         emit IncentiveContractUpdate(account, incentive);
44     }
45 
46     /// @notice mint FEI tokens
47     /// @param account the account to mint to
48     /// @param amount the amount to mint
49     function mint(address account, uint256 amount) external override onlyMinter whenNotPaused {
50         _mint(account, amount);
51         emit Minting(account, msg.sender, amount);
52     }
53 
54     /// @notice burn FEI tokens from caller
55     /// @param amount the amount to burn
56     function burn(uint256 amount) public override(IFei, ERC20Burnable) {
57         super.burn(amount);
58         emit Burning(msg.sender, msg.sender, amount);
59     }
60 
61     /// @notice burn FEI tokens from specified account
62     /// @param account the account to burn from
63     /// @param amount the amount to burn
64     function burnFrom(address account, uint256 amount) public override(IFei, ERC20Burnable) onlyBurner whenNotPaused {
65         _burn(account, amount);
66         emit Burning(account, msg.sender, amount);
67     }
68 
69     function _transfer(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) internal override {
74         super._transfer(sender, recipient, amount);
75         _checkAndApplyIncentives(sender, recipient, amount);
76     }
77 
78     function _checkAndApplyIncentives(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) internal {
83         // incentive on sender
84         address senderIncentive = incentiveContract[sender];
85         if (senderIncentive != address(0)) {
86             IIncentive(senderIncentive).incentivize(sender, recipient, msg.sender, amount);
87         }
88 
89         // incentive on recipient
90         address recipientIncentive = incentiveContract[recipient];
91         if (recipientIncentive != address(0)) {
92             IIncentive(recipientIncentive).incentivize(sender, recipient, msg.sender, amount);
93         }
94 
95         // incentive on operator
96         address operatorIncentive = incentiveContract[msg.sender];
97         if (msg.sender != sender && msg.sender != recipient && operatorIncentive != address(0)) {
98             IIncentive(operatorIncentive).incentivize(sender, recipient, msg.sender, amount);
99         }
100 
101         // all incentive, if active applies to every transfer
102         address allIncentive = incentiveContract[address(0)];
103         if (allIncentive != address(0)) {
104             IIncentive(allIncentive).incentivize(sender, recipient, msg.sender, amount);
105         }
106     }
107 
108     /// @notice permit spending of FEI
109     /// @param owner the FEI holder
110     /// @param spender the approved operator
111     /// @param value the amount approved
112     /// @param deadline the deadline after which the approval is no longer valid
113     function permit(
114         address owner,
115         address spender,
116         uint256 value,
117         uint256 deadline,
118         uint8 v,
119         bytes32 r,
120         bytes32 s
121     ) external override {
122         require(deadline >= block.timestamp, "Fei: EXPIRED");
123         bytes32 digest = keccak256(
124             abi.encodePacked(
125                 "\x19\x01",
126                 DOMAIN_SEPARATOR,
127                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
128             )
129         );
130         address recoveredAddress = ecrecover(digest, v, r, s);
131         require(recoveredAddress != address(0) && recoveredAddress == owner, "Fei: INVALID_SIGNATURE");
132         _approve(owner, spender, value);
133     }
134 }
