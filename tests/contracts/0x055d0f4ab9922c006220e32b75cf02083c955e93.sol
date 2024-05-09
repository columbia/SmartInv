# @version ^0.3.9
# @title TokenRedeemer

"""
Token redemption contract where users can redeem their tokens for ETH.
They get (accumulated ETH) / (total supply) * (token balance)
"""

from vyper.interfaces import ERC20

token: public(ERC20)

interface MintableBurnableToken:
    def mint(amount: uint256): nonpayable
    def burn(amount: uint256): nonpayable

event Redeemed:
    redeemer: indexed(address)
    amount_earned: uint256
    amount_burned: uint256

@external
def __init__(_token: ERC20):
    self.token = _token

event Attempt:
    user: indexed(address)
    amount: uint256
    allowance: uint256
    balance: uint256

@external
def redeem(amount: uint256 = 0):
    """
    Redeem tokens for ETH.
    """
    totalSupply: uint256 = self.token.totalSupply()

    amount_to_burn: uint256 = amount
    if amount_to_burn == 0:
        amount_to_burn = self.token.balanceOf(msg.sender)

    amount_earned: uint256 = (self.balance * amount_to_burn) / totalSupply

    assert self.token.allowance(msg.sender, self) >= amount_to_burn, "Not enough allowance"
    assert self.token.balanceOf(msg.sender) >= amount_to_burn, "Not enough balance"

    log Attempt(msg.sender, amount_to_burn, self.token.allowance(msg.sender, self), self.token.balanceOf(msg.sender))

    self.token.transferFrom(msg.sender, self, amount_to_burn)

    send(msg.sender, amount_earned)
    MintableBurnableToken(self.token.address).burn(amount_to_burn)

    log Redeemed(msg.sender, amount_earned, amount_to_burn)

@view
@external
def claimable_amount(user: address) -> uint256:
    """
    Returns the amount of ETH that can be claimed.
    """
    totalSupply: uint256 = self.token.totalSupply()
    return (self.balance * self.token.balanceOf(user)) / totalSupply

@payable
@external
def __default__():
    """
    Fallback function to receive ETH.
    """
    pass