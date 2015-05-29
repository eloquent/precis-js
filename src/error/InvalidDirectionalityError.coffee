module.exports = class InvalidDirectionalityError extends Error

    constructor: -> @message = 'String violates the directionality rule.'
