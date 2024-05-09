# @dev Implementation of ERC-20 token standard.
# @author Takayuki Jimba (@yudetamago)
# @autho VROOM.bet (@vroom_bet)
# https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

from vyper.interfaces import ERC20
from vyper.interfaces import ERC20Detailed

implements: ERC20
implements: ERC20Detailed

event Transfer:
  sender: indexed(address)
  receiver: indexed(address)
  value: uint256

event Approval:
  owner: indexed(address)
  spender: indexed(address)
  value: uint256

MAX_RECIPIENTS: constant(uint256) = 100
BURN_ADDRESS: constant(address) = 0x000000000000000000000000000000000000dEaD

name: public(String[32])
symbol: public(String[32])
decimals: public(uint8)
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])
totalSupply: public(uint256)
owner: public(address)

tradingEnabled: public(bool)
ammPairs: public(HashMap[address, bool])

buyFees: public(uint256)
sellFees: public(uint256)
excludedFromFees: public(HashMap[address, bool])

maxTxAmount: public(uint256)
excludedFromMaxTxAmount: public(HashMap[address, bool])

@external
def __init__():
  # token params
  self.name = "VROOM"
  self.symbol = "VROOM"
  self.decimals = 18
  self.totalSupply = 3_000_000_000 * 10 ** 18
  self.owner = msg.sender

  # anti-bots params for launch
  self.tradingEnabled = False
  self.buyFees = 30
  self.sellFees = 30
  self.maxTxAmount = self.totalSupply / 100

  # mint all tokens to owner
  self.balanceOf[msg.sender] = self.totalSupply
  log Transfer(empty(address), msg.sender, self.totalSupply)

  # exlude owner from fees and transfer ban
  self.excludedFromFees[msg.sender] = True
  self.excludedFromMaxTxAmount[msg.sender] = True

  # exclude team tokens wallet from bans
  self.excludedFromFees[0x2e38856eB6F2a0aAF13cE7ce98e34901884c517C] = True
  self.excludedFromMaxTxAmount[0x2e38856eB6F2a0aAF13cE7ce98e34901884c517C] = True

@external
def transfer(_to: address, _value: uint256) -> bool:
  return self._transfer(msg.sender, _to, _value, msg.sender)

@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
  assert _value <= self.allowance[_from][msg.sender], "Insufficient allowance"
  self.allowance[_from][msg.sender] -= _value
  return self._transfer(_from, _to, _value, msg.sender)

@internal
def _transfer(_from: address, _to: address, _value: uint256, _sender: address) -> bool:
  assert _to != empty(address), "Can't transfer to zero address"
  assert self.balanceOf[_from] >= _value, "Insufficient balance"
  assert self.tradingEnabled or self.excludedFromMaxTxAmount[_sender] == True, "Trading not enabled"

  if (self.ammPairs[_from] == True and self.excludedFromMaxTxAmount[_to] == False) or (self.ammPairs[_to] == True and self.excludedFromMaxTxAmount[_from] == False):
    assert _value <= self.maxTxAmount, "Transfer amount exceeds the maxTxAmount."

  # first decrease the balance of the sender
  self.balanceOf[_from] -= _value

  # calculate if fees applies
  feesAmount: uint256 = 0
  if self.ammPairs[_from] == True and self.excludedFromFees[_to] == False:
    feesAmount = _value * self.buyFees / 100
  elif self.ammPairs[_to] == True and self.excludedFromFees[_from] == False:
      feesAmount = _value * self.sellFees / 100

  # increase the balance of the receiver
  self.balanceOf[_to] += _value - feesAmount
  self.balanceOf[BURN_ADDRESS] += feesAmount

  log Transfer(_from, _to, _value - feesAmount)

  return True

@external
def approve(_spender: address, _value: uint256) -> bool:
  self.allowance[msg.sender][_spender] = _value
  log Approval(msg.sender, _spender, _value)
  return True

@external
def renounceOwnership() -> bool:
  assert msg.sender == self.owner, "Only owner can renounce ownership"
  self.owner = empty(address)
  return True

@external
def enableTrading() -> bool:
  assert msg.sender == self.owner, "Only owner can enable trading"
  self.tradingEnabled = True
  return True

@external
def addAMMPair(_pair: address) -> bool:
  assert msg.sender == self.owner, "Only owner can add AMM pair"
  assert self.ammPairs[_pair] == False, "AMM pair already added"
  self.ammPairs[_pair] = True
  return True

@external
def updateFees(_buyFees: uint256, _sellFees: uint256) -> bool:
  assert msg.sender == self.owner, "Only owner can update fees"
  assert _buyFees <= 100 and _sellFees <= 100, "Fees can't be more than 100%"
  self.buyFees = _buyFees
  self.sellFees = _sellFees
  return True

@external
def addExcludedFromMaxTxAmount(_address: address) -> bool:
  assert msg.sender == self.owner, "Only owner can add excluded from fees"
  assert self.excludedFromMaxTxAmount[_address] == False, "Address already excluded from fees"
  self.excludedFromMaxTxAmount[_address] = True
  return True

@external
def multiTransfer(_recipients: address[MAX_RECIPIENTS], _amounts: uint256[MAX_RECIPIENTS]) -> bool:
  assert msg.sender == self.owner, "Only owner can multi transfer"

  totalAmount: uint256 = 0
  for i in range(MAX_RECIPIENTS):
    if _recipients[i] == empty(address):
      break
    totalAmount += _amounts[i]

  assert self.balanceOf[msg.sender] >= totalAmount, "Insufficient balance"

  for i in range(MAX_RECIPIENTS):
    if _recipients[i] == empty(address):
      break
    self._transfer(msg.sender, _recipients[i], _amounts[i], msg.sender)

  return True