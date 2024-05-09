1 # @version ^0.3.9
2 # @title TokenRedeemer
3 
4 """
5 Token redemption contract where users can redeem their tokens for ETH.
6 They get (accumulated ETH) / (total supply) * (token balance)
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 token: public(ERC20)
12 
13 interface MintableBurnableToken:
14     def mint(amount: uint256): nonpayable
15     def burn(amount: uint256): nonpayable
16 
17 event Redeemed:
18     redeemer: indexed(address)
19     amount_earned: uint256
20     amount_burned: uint256
21 
22 @external
23 def __init__(_token: ERC20):
24     self.token = _token
25 
26 event Attempt:
27     user: indexed(address)
28     amount: uint256
29     allowance: uint256
30     balance: uint256
31 
32 @external
33 def redeem(amount: uint256 = 0):
34     """
35     Redeem tokens for ETH.
36     """
37     totalSupply: uint256 = self.token.totalSupply()
38 
39     amount_to_burn: uint256 = amount
40     if amount_to_burn == 0:
41         amount_to_burn = self.token.balanceOf(msg.sender)
42 
43     amount_earned: uint256 = (self.balance * amount_to_burn) / totalSupply
44 
45     assert self.token.allowance(msg.sender, self) >= amount_to_burn, "Not enough allowance"
46     assert self.token.balanceOf(msg.sender) >= amount_to_burn, "Not enough balance"
47 
48     log Attempt(msg.sender, amount_to_burn, self.token.allowance(msg.sender, self), self.token.balanceOf(msg.sender))
49 
50     self.token.transferFrom(msg.sender, self, amount_to_burn)
51 
52     send(msg.sender, amount_earned)
53     MintableBurnableToken(self.token.address).burn(amount_to_burn)
54 
55     log Redeemed(msg.sender, amount_earned, amount_to_burn)
56 
57 @view
58 @external
59 def claimable_amount(user: address) -> uint256:
60     """
61     Returns the amount of ETH that can be claimed.
62     """
63     totalSupply: uint256 = self.token.totalSupply()
64     return (self.balance * self.token.balanceOf(user)) / totalSupply
65 
66 @payable
67 @external
68 def __default__():
69     """
70     Fallback function to receive ETH.
71     """
72     pass