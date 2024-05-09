1 # @version 0.3.1
2 """
3 @title Token Minter
4 @author Curve Finance
5 @license MIT
6 """
7 
8 # Original idea and credit:
9 # Curve Finance's Token Minter
10 # https://resources.curve.fi/base-features/understanding-gauges
11 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/Minter.vy
12 # This contract is an almost-identical fork of Curve's contract
13 
14 interface LiquidityGauge:
15     # Presumably, other gauges will provide the same interfaces
16     def integrate_fraction(addr: address) -> uint256: view
17     def user_checkpoint(addr: address) -> bool: nonpayable
18 
19 interface MERC20:
20     def mint(_to: address, _value: uint256) -> bool: nonpayable
21 
22 interface GaugeController:
23     def gauge_types(addr: address) -> int128: view
24 
25 
26 event Minted:
27     recipient: indexed(address)
28     gauge: address
29     minted: uint256
30 
31 
32 token: public(address)
33 controller: public(address)
34 
35 # user -> gauge -> value
36 minted: public(HashMap[address, HashMap[address, uint256]])
37 
38 # minter -> user -> can mint?
39 allowed_to_mint_for: public(HashMap[address, HashMap[address, bool]])
40 
41 
42 @external
43 def __init__(_token: address, _controller: address):
44     self.token = _token
45     self.controller = _controller
46 
47 
48 @internal
49 def _mint_for(gauge_addr: address, _for: address):
50     assert GaugeController(self.controller).gauge_types(gauge_addr) >= 0  # dev: gauge is not added
51 
52     LiquidityGauge(gauge_addr).user_checkpoint(_for)
53     total_mint: uint256 = LiquidityGauge(gauge_addr).integrate_fraction(_for)
54     to_mint: uint256 = total_mint - self.minted[_for][gauge_addr]
55 
56     if to_mint != 0:
57         MERC20(self.token).mint(_for, to_mint)
58         self.minted[_for][gauge_addr] = total_mint
59 
60         log Minted(_for, gauge_addr, total_mint)
61 
62 
63 @external
64 @nonreentrant('lock')
65 def mint(gauge_addr: address):
66     """
67     @notice Mint everything which belongs to `msg.sender` and send to them
68     @param gauge_addr `LiquidityGauge` address to get mintable amount from
69     """
70     self._mint_for(gauge_addr, msg.sender)
71 
72 
73 @external
74 @nonreentrant('lock')
75 def mint_many(gauge_addrs: address[8]):
76     """
77     @notice Mint everything which belongs to `msg.sender` across multiple gauges
78     @param gauge_addrs List of `LiquidityGauge` addresses
79     """
80     for i in range(8):
81         if gauge_addrs[i] == ZERO_ADDRESS:
82             break
83         self._mint_for(gauge_addrs[i], msg.sender)
84 
85 
86 @external
87 @nonreentrant('lock')
88 def mint_for(gauge_addr: address, _for: address):
89     """
90     @notice Mint tokens for `_for`
91     @dev Only possible when `msg.sender` has been approved via `toggle_approve_mint`
92     @param gauge_addr `LiquidityGauge` address to get mintable amount from
93     @param _for Address to mint to
94     """
95     if self.allowed_to_mint_for[msg.sender][_for]:
96         self._mint_for(gauge_addr, _for)
97 
98 
99 @external
100 def toggle_approve_mint(minting_user: address):
101     """
102     @notice allow `minting_user` to mint for `msg.sender`
103     @param minting_user Address to toggle permission for
104     """
105     self.allowed_to_mint_for[minting_user][msg.sender] = not self.allowed_to_mint_for[minting_user][msg.sender]