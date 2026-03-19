<a href="https://rubygems.org/gems/antlers" title="Install gem"><img src="https://badge.fury.io/rb/antlers.svg" alt="Gem version" height="18"></a>

# `<{` Antlers `}>`

A new Ruby templating language. Coming soon...

## Syntax

### Props

```ruby
def render
  <html><{ UserNode user=@user }></html>
end
```

### Slots

```ruby
def render
  <html>
    <{ LayoutNode: username = @user.username }>
      <{ UserNode user = @user }>
    <{ :LayoutNode }>
  </html>
end
```

### Conditionals

```ruby
# Block.
<{ if: @user.happy? }>
  <{ UserNode user = @user }>
<{ :if }>

# Directive.
<{ UserNode user = @user if: @user.happy? }>
```

### Loops

```ruby
# Block.
<{ for: user in: @users }>
  <{ UserNode user = user }>
<{ :for }>

# Directive.
<{ UserNode user = user for: user in: @users }>
```

## Philosophy

Antlers is not Ruby, but its syntax is built using Ruby syntax elements in order to look good out of the box with default syntax highlighting.
