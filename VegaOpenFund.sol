pragma solidity ^0.4.18;
contract SafeMath {
  function safeMul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeSub(uint a, uint b) internal returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c>=a && c>=b);
    return c;
  }

  function assert(bool assertion) internal {
    if (!assertion) throw;
  }
    function multiplyPercentage(uint _value, uint _numerator, uint _denominator) public constant returns (uint) {
        uint value = (_value * _numerator) / _denominator;
        return value;
    }
}


contract VegaOpenFund is SafeMath{

    mapping (address => uint256) public balances;
    uint public totalSupply;
    uint public etherHoldings;

    event LogSubscription(address sender, uint amount);
    event LogRedemption(address receiver, uint amount);
    event LogTransfer(address sender, address to, uint amount);

    // Get the price per token in the Vega Open Fund.
    function getCurrentTokenPriceInEth() public constant returns (uint) {
        uint price = etherHoldings / totalSupply;
        return price;
    }

    // Subscribe to tokens in the Vega Open Fund.
    function subscribe() payable returns(bool success) {
        uint amount = msg.value / getCurrentTokenPriceInEth();
        balances[msg.sender] +=amount;
        totalSupply += amount;
        etherHoldings += msg.value;
        LogSubscription(msg.sender, amount);
        return true;
    }

    // Redeem fund interests in the Vega Open Fund.
    function redeem(uint tokens) returns(bool success) {
        if(balances[msg.sender] < tokens) throw;
        balances[msg.sender] -= tokens;
        uint amount = safeMul(tokens, getCurrentTokenPriceInEth());
        msg.sender.transfer(amount);
        totalSupply -= tokens;
        etherHoldings -= amount;
        LogRedemption(msg.sender, tokens);
        return true;
    }

    // Transfer VFT from one account to another.
    function transfer(address to, uint tokens) returns(bool success) {
        if(balances[msg.sender] < tokens) throw;
        balances[msg.sender] -= tokens;
        to.transfer(tokens);
        LogTransfer(msg.sender, to, tokens);
        return true;
    }
}
