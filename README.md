<a href="https://rubygems.org/gems/antlers" title="Install gem"><img src="https://badge.fury.io/rb/antlers.svg" alt="Gem version" height="18"></a>

# Antlers

`<{ Antlers }>` is a templating language designed to be embedded within HTML that is directly embedded within a Ruby file.
This gives Antlers access to the class it's embedded in at runtime where it can perform additional logic.

Antlers is currently used in [LowNode](https://github.com/low-rb/low_node) to render child nodes in parallel via immutable state.

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

**#️⃣ Syntax.** Antlers is not Ruby, but reuses Ruby's syntax in order to have syntax highlighting out of the box in a Ruby file.
