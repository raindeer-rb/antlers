<a href="https://rubygems.org/gems/antlers" title="Install gem"><img src="https://badge.fury.io/rb/antlers.svg" alt="Gem version" height="18"></a>

# Antlers

`<{ Antlers }>` is a templating language designed to be embedded within HTML, where that HTML itself is embedded within a Ruby file.
This gives Antlers access to the class it's embedded in at runtime where it can perform additional logic.

Antlers is currently used in [LowNode](https://github.com/low-rb/low_node) to render child nodes in a compositional way.

## Syntax

### Components

Render a class named `UserNode` with:
```ruby
def render
  <html><{ UserNode }></html>
end
```

**Props:**
```ruby
def render
  <html><{ UserNode user=@user }></html>
end
```

**Slots:** [UNRELEASED]
```ruby
def render
  <html>
    <{ LayoutNode: username=@user.username }>
      <{ UserNode user=@user }>
    <{ :LayoutNode }>
  </html>
end
```

### Conditionals [UNRELEASED]

```ruby
# Block.
<{ if: @user.happy? }>
  <{ UserNode user=@user }>
<{ :if }>

# Directive.
<{ UserNode user=@user if: @user.happy? }>
```

### Loops [UNRELEASED]

```ruby
# Block.
<{ for: user in: @users }>
  <{ UserNode user=user }>
<{ :for }>

# Directive.
<{ UserNode user=user for: user in: @users }>

# Directive with simplified prop.
<{ UserNode user for: user in: @users }>
```

## Philosophy

**#️⃣ Syntax.** Antlers is not Ruby, but compiles to Ruby, and looks like Ruby in order to get syntax highlighting out of the box.
