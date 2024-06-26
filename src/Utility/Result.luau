export type Result<T> = Ok<T> | Err
export type Ok<T> = { ok: true, value: T }
export type Err = { ok: false, reason: string }

local Result = {}

function Result.err(reason: string): Err
   return table.freeze { ok = false :: false, reason = reason }
end

function Result.ok<T>(value: T): Ok<T>
   return table.freeze { ok = true :: true, value = value }
end

function Result.unwrap<T>(result: Result<T>): T?
   if result.ok then
      return result.value
   end
   return nil
end

table.freeze(Result)
return Result
