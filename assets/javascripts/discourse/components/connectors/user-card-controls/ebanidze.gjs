import LinkTo from '@ember/routing/link-to-component'
import dIcon from 'discourse/helpers/d-icon'

export default <template>
  {{! @outletArgs.user contains the user record for the popped-open card }}
  <LinkTo @route="user.kek" @model={{@outletArgs.user.username}} class="btn btn-default user-card-reviews-btn">
    {{dIcon "star-half-stroke"}}
    Отзывы
  </LinkTo>
</template>
