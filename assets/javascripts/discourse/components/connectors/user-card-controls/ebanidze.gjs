import Link from '@ember/routing/link-component'
import dIcon from 'discourse/helpers/d-icon'

export default <template>
  {{! @outletArgs.user contains the user record for the popped-open card }}
  <Link @route="user.kek" @model={{@outletArgs.user.username}} class="btn btn-default user-card-reviews-btn">
    {{dIcon "star-half-stroke"}}
    Отзывы
  </Link>
</template>
