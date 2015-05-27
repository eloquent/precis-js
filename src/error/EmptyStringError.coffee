module.exports = class EmptyStringError extends Error

    constructor: -> @message = 'String cannot be empty.'
